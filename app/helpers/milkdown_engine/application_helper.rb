# frozen_string_literal: true

module MilkdownEngine
  module ApplicationHelper
    CONTROLLER_ID = "milkdown-engine--editor"
    EMPTY_DOC = { type: "doc", content: [{ type: "paragraph" }] }.to_json.freeze

    # Renders a Milkdown editor wired to a hidden <input> for form submission.
    #
    # The hidden input holds the ProseMirror JSON representation of the document.
    # On every content change the Stimulus controller serialises the editor state
    # back into the hidden input so it is submitted with the form.
    #
    # The outer wrapper gets Fomantic-UI +ui segment+ classes so it integrates
    # visually with rails-active-ui / Fomantic-UI layouts.
    #
    # ==== Options
    #
    # * <tt>:readonly</tt>  – boolean, defaults to +false+.
    # * <tt>:label</tt>     – optional label text rendered above the editor.
    # * <tt>:class</tt>     – extra CSS class(es) added to the outer wrapper.
    # * <tt>:editor_html</tt> – extra HTML attributes for the inner editor div.
    #
    # ==== Examples
    #
    #   # Standalone (no form builder)
    #   <%= milkdown_editor "md_document[content]", @document.content %>
    #
    #   # Inside a Fomantic-UI form
    #   <% Form { %>
    #     <div class="field">
    #       <%= milkdown_editor "md_document[content]", @document.content, label: "Content" %>
    #     </div>
    #     <% Button(variant: :primary, type: :submit) { text "Save" } %>
    #   <% } %>
    #
    #   # With a Rails form builder
    #   <%= form_with model: @document, html: { class: "ui form" } do |f| %>
    #     <%= milkdown_editor_field f, :content, label: "Content" %>
    #   <% end %>
    #
    def milkdown_editor(name, value = nil, readonly: false, label: nil, **html_options)
      editor_html = html_options.delete(:editor_html) || {}

      json_value = case value
                   when String then value.presence || EMPTY_DOC
                   when Hash   then value.present? ? value.to_json : EMPTY_DOC
                   when nil    then EMPTY_DOC
                   else value.to_json
                   end

      extra_class = html_options.delete(:class)
      wrapper_classes = class_names("ui segment milkdown-editor", extra_class)

      wrapper_attrs = html_options.merge(
        class: wrapper_classes,
        data: {
          controller: CONTROLLER_ID,
          "#{CONTROLLER_ID}-readonly-value": readonly
        }
      )

      parts = []
      parts << content_tag(:label, label, class: "milkdown-editor-label") if label
      parts << hidden_field_tag(name, json_value, data: { "#{CONTROLLER_ID}-target": "input" })
      parts << content_tag(:div, "", editor_html.merge(
        class: class_names("milkdown-editor-surface", editor_html[:class]),
        data: { "#{CONTROLLER_ID}-target": "editor" }
      ))

      content_tag(:div, wrapper_attrs) { safe_join(parts) }
    end

    # Form-builder variant: reads the field value from the model automatically.
    #
    #   <%= form_with model: @document, html: { class: "ui form" } do |f| %>
    #     <%= milkdown_editor_field f, :content, label: "Content" %>
    #   <% end %>
    #
    def milkdown_editor_field(form, method, **options)
      record = form.object
      value  = record&.public_send(method)
      name   = "#{form.object_name}[#{method}]"

      milkdown_editor(name, value, **options)
    end
  end
end
