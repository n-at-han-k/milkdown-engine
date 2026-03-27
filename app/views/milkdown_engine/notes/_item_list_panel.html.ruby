ResourceListBlock(
  heading:          "Notes",
  search_url:       notes_path,
  search_query:     @q,
  search_predicate: "title_cont",
  resources:        @notes,
  item_partial:     "milkdown_engine/notes/note_card",
  item_local:       "note",
  new_path:         new_note_path,
  turbo_frame:      "notes-list",
  id:               "item-list-panel",
  data: {
    turbo_permanent: true,
    controller: "milkdown-engine--item-list",
    "milkdown-engine--item-list-selected-id-value": (defined?(@note) && @note&.persisted? ? @note.id : 0)
  },
  search_form_data: {
    controller: "milkdown-engine--auto-submit",
    action:     "input->milkdown-engine--auto-submit#submit"
  }
)
