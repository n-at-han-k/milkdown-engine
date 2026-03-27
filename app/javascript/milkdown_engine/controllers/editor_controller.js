import { Controller } from "@hotwired/stimulus"
import {
  Crepe,
  editorViewCtx,
  schemaCtx,
  Node,
} from "milkdown_engine/milkdown"

// Stimulus controller that wraps a Milkdown Crepe editor instance.
//
// Usage:
//   <div data-controller="milkdown-engine--editor"
//        data-milkdown-engine--editor-readonly-value="false">
//     <input type="hidden"
//            data-milkdown-engine--editor-target="input"
//            name="document[content]"
//            value='{"type":"doc","content":[]}'>
//     <div data-milkdown-engine--editor-target="editor"></div>
//   </div>
//
// The controller reads initial JSON from the hidden input, initialises the
// Milkdown editor inside the [data-target="editor"] element, and keeps the
// hidden input in sync with the document's ProseMirror JSON on every change.
//
// Dispatches a "milkdown-engine--editor:change" CustomEvent on the controller
// element whenever the document changes.  event.detail.content holds the JSON.

export default class extends Controller {
  static targets = ["editor", "input"]
  static values = {
    readonly: { type: Boolean, default: false },
  }

  async connect() {
    this.crepe = new Crepe({
      root: this.editorTarget,
      features: {
        // Latex is heavy and rarely needed — disabled by default
        latex: false,
      },
    })

    // Wire up the change listener *before* create() so it captures the
    // initial mount as well.
    this.crepe.on((listener) => {
      listener.updated((_ctx, doc, _prevDoc) => {
        this.#syncToInput(doc.toJSON())
      })
    })

    await this.crepe.create()

    // If the hidden input carries existing JSON, replace the empty doc.
    this.#loadInitialContent()

    if (this.readonlyValue) {
      this.crepe.setReadonly(true)
    }
  }

  async disconnect() {
    if (this.crepe) {
      await this.crepe.destroy()
      this.crepe = null
    }
  }

  // --- public API (callable via Stimulus actions or from other controllers) ---

  // Returns the current document as ProseMirror JSON.
  getJSON() {
    return this.crepe.editor.action((ctx) => {
      const view = ctx.get(editorViewCtx)
      return view.state.doc.toJSON()
    })
  }

  // Replaces the entire document from a ProseMirror JSON object.
  setJSON(json) {
    this.crepe.editor.action((ctx) => {
      const view = ctx.get(editorViewCtx)
      const schema = ctx.get(schemaCtx)
      const doc = Node.fromJSON(schema, json)
      view.dispatch(
        view.state.tr.replaceWith(0, view.state.doc.content.size, doc.content)
      )
    })
  }

  // --- Stimulus value callbacks ---

  readonlyValueChanged() {
    if (this.crepe) {
      this.crepe.setReadonly(this.readonlyValue)
    }
  }

  // --- private ---

  #syncToInput(json) {
    if (this.hasInputTarget) {
      this.inputTarget.value = JSON.stringify(json)
    }
    this.dispatch("change", { detail: { content: json } })
  }

  #loadInitialContent() {
    if (!this.hasInputTarget) return

    const raw = this.inputTarget.value
    if (!raw || raw === "" || raw === "{}") return

    try {
      const json = JSON.parse(raw)
      if (json && json.type === "doc" && json.content) {
        this.setJSON(json)
      }
    } catch {
      // The input does not contain valid JSON — start with an empty document.
    }
  }
}
