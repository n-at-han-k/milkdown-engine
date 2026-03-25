Container {
  Header(size: :h1) { text "New document" }
  output_buffer << render("form", document: @document)
  Divider(hidden: true)
  Button(href: documents_path, icon: "arrow left") { text "Back" }
}
