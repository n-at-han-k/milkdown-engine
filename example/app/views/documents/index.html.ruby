Container {
  Header(size: :h1) { text "Documents" }

  Button(href: new_document_path, variant: :primary, icon: "plus") { text "New document" }
  Divider(hidden: true)

  if @documents.any?
    Table(striped: true, celled: true, rows: @documents) { |c|
      c.column(:title, heading: "Title") { |doc|
        Link(href: document_path(doc)) { text doc.title.presence || "Untitled ##{doc.id}" }
      }
      c.column(:updated_at, heading: "Updated") { |doc|
        text time_ago_in_words(doc.updated_at) + " ago"
      }
    }
  else
    Message(type: :info) { text "No documents yet." }
  end
}
