Wrapper(id: "md-app") {
  Partial("milkdown_engine/notes/item_list_panel")
  Partial("milkdown_engine/notes/content_editor") {
    Wrapper(html_class: "editor-title-bar") {
      Partial("title_form", note: @note)
    }
    Wrapper(html_class: "editor-content") {
      Partial("content_form", note: @note)
    }
  }
}
