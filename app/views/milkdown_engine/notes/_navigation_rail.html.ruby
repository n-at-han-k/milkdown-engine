Wrapper(id: "navigation-rail") {
  Wrapper(id: "navigation-rail-search") {
    Input(fluid: true, icon: "search", placeholder: "Search tags…")
  }

  Wrapper(html_class: "rail-section-label") { text "Views" }

  Wrapper(id: "navigation-rail-views") {
    Menu(vertical: true) {
      MenuItem(active: true, icon: "list") { text "Notes" }
      MenuItem(icon: "folder") { text "Files" }
      MenuItem(icon: "star") { text "Starred" }
      MenuItem(icon: "archive") { text "Archived" }
      MenuItem(icon: "trash") { text "Trash" }
      MenuItem(icon: "tag") { text "Untagged" }
    }
  }

  Wrapper(html_class: "rail-section-label") { text "Tags" }

  Wrapper(id: "navigation-rail-tags") {
    Menu(vertical: true) {
      MenuItem(icon: "hashtag") { text "construction" }
      MenuItem(icon: "hashtag") { text "clients" }
      MenuItem(icon: "hashtag") { text "invoices" }
      MenuItem(icon: "hashtag") { text "site-visits" }
      MenuItem(icon: "hashtag") { text "materials" }
    }
  }
}
