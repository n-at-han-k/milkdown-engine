Form(model: note, url: note.persisted? ? note_path(note) : notes_path, data: { controller: "milkdown-engine--auto-submit", action: "input->milkdown-engine--auto-submit#submit" }) {
  Input(transparent: true, fluid: true, name: "document[title]", value: note.title, placeholder: "Untitled")
}
