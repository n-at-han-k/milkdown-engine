Container {
  Header(size: :h1) { text @document.title.presence || "Untitled" }

  output_buffer << milkdown_editor("content", @document.content, readonly: true)

  Divider(hidden: true)

  HStack(spacing: 8) {
    Button(href: edit_document_path(@document), icon: "edit") { text "Edit" }
    Button(href: documents_path, icon: "arrow left") { text "Back" }
    Button(href: document_path(@document), color: :red, icon: "trash") { text "Delete" }
  }

  headings = @document.headings rescue []
  if headings.any?
    Divider(section: true)
    Header(size: :h3, icon: "list", dividing: true) { text "Table of Contents" }
    List(bulleted: true) {
      headings.each do |h|
        output_buffer << tag.div(class: "item", style: "margin-left: #{(h.level - 1) * 1.5}rem;") {
          safe_join([
            tag.a(h.text, href: "##{h.id}"),
            " ".html_safe,
            tag.span("h#{h.level}", class: "ui mini label")
          ])
        }
      end
    }
  end

  items = @document.checklist_items rescue []
  if items.any?
    Divider(section: true)
    Header(size: :h3, icon: "tasks", dividing: true) { text "Checklist Items" }
    List {
      items.each do |item|
        output_buffer << tag.div(class: "item") {
          Checkbox(label_text: item.text, checked: item.checked, read_only: true)
        }
      end
    }
  end

  if @document.content.present?
    Divider(section: true)
    Header(size: :h3, icon: "code", dividing: true) { text "Raw JSON" }
    Segment(secondary: true) {
      output_buffer << tag.pre(tag.code(JSON.pretty_generate(@document.content)))
    }
  end
}
