# frozen_string_literal: true

module MilkdownEngine
  class MdDocument < ApplicationRecord
    ChecklistItem = Data.define(:text, :checked)
    Heading       = Data.define(:level, :id, :text)

    validates :content, presence: true

    before_save :set_title_from_content, if: -> { title.blank? && content_changed? }

    # ── JSON query helpers (PostgreSQL jsonb_path_query) ─────────────────

    # Extract task-list items from the ProseMirror JSON stored in +content+.
    #
    # In Milkdown's ProseMirror output, task-list items are regular
    # +list_item+ nodes whose +attrs.checked+ is +true+ or +false+
    # (regular list items have +checked: null+).
    #
    # Returns an Array of ChecklistItem (text:, checked:).
    def checklist_items
      rows = exec_jsonb_query(<<~SQL.squish)
        SELECT
          (item #>> '{attrs,checked}')::boolean AS checked,
          string_agg(text_node #>> '{text}', '' ORDER BY text_ord) AS item_text
        FROM jsonb_path_query(
          (SELECT content FROM milkdown_engine_md_documents WHERE id = :id),
          'strict $.** ? (@.type == "list_item" && @.attrs.checked != null)'
        ) WITH ORDINALITY AS items(item, item_ord),
        jsonb_path_query(item, 'strict $.** ? (@.type == "text")') WITH ORDINALITY AS texts(text_node, text_ord)
        GROUP BY items.item_ord, item #>> '{attrs,checked}'
        ORDER BY items.item_ord
      SQL

      rows.map { |row| ChecklistItem.new(text: row["item_text"], checked: row["checked"]) }
    end

    # Extract every heading from the document.
    #
    # Returns an Array of Heading (level:, id:, text:) in document order.
    # Useful for building a table of contents.
    def headings
      rows = exec_jsonb_query(<<~SQL.squish)
        SELECT
          (heading #>> '{attrs,level}')::integer AS level,
          heading #>> '{attrs,id}'                AS id,
          string_agg(text_node #>> '{text}', '' ORDER BY text_ord) AS heading_text
        FROM jsonb_path_query(
          (SELECT content FROM milkdown_engine_md_documents WHERE id = :id),
          'strict $.** ? (@.type == "heading")'
        ) WITH ORDINALITY AS headings(heading, heading_ord),
        jsonb_path_query(heading, 'strict $.** ? (@.type == "text")') WITH ORDINALITY AS texts(text_node, text_ord)
        GROUP BY headings.heading_ord, heading #>> '{attrs,level}', heading #>> '{attrs,id}'
        ORDER BY headings.heading_ord
      SQL

      rows.map { |row| Heading.new(level: row["level"], id: row["id"], text: row["heading_text"]) }
    end

    alias_method :table_of_contents, :headings

    private

    # Execute a raw SQL string that contains jsonb_path_query expressions.
    #
    # We avoid +sanitize_sql_array+ here because its +?+ placeholder syntax
    # conflicts with the +?+ filter operator in PostgreSQL jsonb path
    # expressions (e.g. '$.** ? (@.type == "heading")').
    #
    # Instead we interpolate the quoted id via +:id+ and +connection.quote+.
    def exec_jsonb_query(sql)
      quoted = sql.gsub(":id", self.class.connection.quote(id))
      self.class.connection.select_all(quoted)
    end

    # Walk the ProseMirror JSON tree in Ruby to find the first heading's text.
    # Runs before save so it doesn't require a DB round-trip.
    def set_title_from_content
      return unless content.is_a?(Hash)

      heading = first_node_of_type(content, "heading")
      return unless heading

      self.title = collect_text(heading).presence
    end

    def first_node_of_type(node, type)
      return node if node["type"] == type

      Array(node["content"]).each do |child|
        found = first_node_of_type(child, type)
        return found if found
      end

      nil
    end

    def collect_text(node)
      return node["text"].to_s if node["type"] == "text"

      Array(node["content"]).map { |child| collect_text(child) }.join
    end
  end
end
