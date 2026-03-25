// Milkdown engine bundle — re-exports the Crepe editor and essential utilities
// for use by the Stimulus controller via importmap.

// Crepe: batteries-included editor (commonmark, GFM, task lists, toolbar, etc.)
export { Crepe } from "@milkdown/crepe"

// Core context slices needed for JSON import/export
export {
  editorViewCtx,
  schemaCtx,
  serializerCtx,
  editorViewOptionsCtx,
} from "@milkdown/kit/core"

// ProseMirror Node class for JSON deserialization
export { Node } from "@milkdown/kit/prose/model"

// Utility macros
export { getMarkdown, replaceAll, insert } from "@milkdown/kit/utils"
