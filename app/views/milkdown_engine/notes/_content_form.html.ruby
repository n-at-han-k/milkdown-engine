Form(model: note, url: note.persisted? ? note_path(note) : notes_path, data: { controller: "milkdown-engine--auto-submit", action: "milkdown-engine--editor:change->milkdown-engine--auto-submit#submit" }) {
  MilkdownEditor(:content)
}
