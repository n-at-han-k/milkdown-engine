output_buffer << form_with(model: note, url: note.persisted? ? note_path(note) : notes_path, html: { class: "ui form" }) { |f|
  if note.errors.any?
    Message(type: :error) { |c|
      c.header { text pluralize(note.errors.count, "error") + " prohibited this note from being saved" }
      note.errors.full_messages.each { |msg| output_buffer << tag.p(msg) }
    }
  end

  output_buffer << tag.div(class: "field") {
    safe_join([
      f.label(:title),
      tag.input(type: "text", name: "document[title]", value: note.title, placeholder: "Auto-filled from first heading if blank")
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
    text note.persisted? ? "Update note" : "Create note"
  }
}
