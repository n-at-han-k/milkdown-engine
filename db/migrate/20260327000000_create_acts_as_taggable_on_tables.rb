# frozen_string_literal: true

# Consolidated migration for acts-as-taggable-on (v13).
# Creates both `tags` and `taggings` tables with all required indexes.

class CreateActsAsTaggableOnTables < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string  :name, null: false
      t.integer :taggings_count, default: 0
      t.timestamps
    end

    add_index :tags, :name, unique: true

    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :taggable, polymorphic: true
      t.references :tagger,   polymorphic: true
      t.string     :context, limit: 128
      t.datetime   :created_at
    end

    add_index :taggings,
              %i[tag_id taggable_id taggable_type context tagger_id tagger_type],
              unique: true, name: "taggings_idx"

    add_index :taggings,
              %i[taggable_id taggable_type context],
              name: "taggings_taggable_context_idx"

    add_index :taggings, %i[tagger_id tagger_type]

    add_index :taggings,
              %i[taggable_id taggable_type tagger_id context],
              name: "taggings_idy"

    add_index :taggings, :context
  end
end
