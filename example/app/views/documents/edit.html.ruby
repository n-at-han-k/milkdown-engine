Container {
  Header(size: :h1) { text "Edit document" }
  output_buffer << render("form", document: @document)
  Divider(hidden: true)
  Button(href: document_path(@document), icon: "arrow left") { text "Back" }
}
