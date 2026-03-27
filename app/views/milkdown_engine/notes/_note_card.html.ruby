Link(href: edit_note_path(note), data: { turbo_frame: "_top", action: "click->milkdown-engine--item-list#select" }) {
  Wrapper(html_class: "note-card", data: { "milkdown-engine--item-list-target": "item", note_id: note.id }) {
    Wrapper(html_class: "note-card-title") { text note.title.presence || "Untitled" }
    Wrapper(html_class: "note-card-meta") { text note.updated_at.strftime("%A, %d %b %Y") }
    note.tag_list.each do |t|
      output_buffer << tag.span(t, class: "note-card-tag")
    end
  }
}
