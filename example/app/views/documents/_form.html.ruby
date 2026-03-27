output_buffer << form_with(model: document, url: document.persisted? ? document_path(document) : documents_path, html: { class: "ui form" }) { |f|
  if document.errors.any?
    Message(type: :error) { |c|
      c.header { text pluralize(document.errors.count, "error") + " prohibited this document from being saved" }
      document.errors.full_messages.each { |msg| output_buffer << tag.p(msg) }
    }
  end

  output_buffer << tag.div(class: "field") {
    safe_join([
      f.label(:title),
      tag.input(type: "text", name: "document[title]", value: document.title, placeholder: "Auto-filled from first heading if blank")
    ])
  }

  output_buffer << tag.div(class: "field") {
    safe_join([
      tag.label("Content"),
      milkdown_editor_field(f, :content)
    ])
  }

  Divider(hidden: true)
  Button(variant: :primary, type: :submit, icon: "save") {
    text document.persisted? ? "Update document" : "Create document"
  }
}
