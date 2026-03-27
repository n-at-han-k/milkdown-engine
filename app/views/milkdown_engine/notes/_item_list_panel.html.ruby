Wrapper(id: "item-list-panel", data: { turbo_permanent: true, controller: "milkdown-engine--item-list", "milkdown-engine--item-list-selected-id-value": (defined?(@note) && @note&.persisted? ? @note.id : 0) }) {
  Wrapper(id: "item-list-header") {
    HStack(spacing: 8, justify: "between", align: "center") {
      Header(size: :h3) { text "Notes" }
      Button(href: new_note_path, size: :mini, icon: "plus", variant: :primary)
    }
  }

  Wrapper(id: "item-list-search") {
    output_buffer << search_form_for(@q, url: notes_path, html: { class: "ui form", data: { turbo_frame: "notes-list", controller: "milkdown-engine--auto-submit", action: "input->milkdown-engine--auto-submit#submit" } }) { |f|
      Input(fluid: true, icon: "search", placeholder: "Search…", name: "q[title_cont]", value: params.dig(:q, :title_cont))
    }
  }

  output_buffer << turbo_frame_tag("notes-list") {
    Wrapper(id: "item-list-scroll") {
      @notes.each do |note|
        Partial("note_card", note: note)
      end
    }
  }
}
