import esbuild from "esbuild"
import { mkdirSync } from "fs"
import { resolve, dirname } from "path"
import { fileURLToPath } from "url"

const __dirname = dirname(fileURLToPath(import.meta.url))
const watching = process.argv.includes("--watch")

const jsOutdir = resolve(__dirname, "app/assets/javascripts/milkdown_engine")
const cssOutdir = resolve(__dirname, "app/assets/stylesheets/milkdown_engine")

mkdirSync(jsOutdir, { recursive: true })
mkdirSync(cssOutdir, { recursive: true })

// Build JS bundle (Milkdown library as a single ESM module)
const jsBuild = {
  entryPoints: [resolve(__dirname, "src/milkdown.js")],
  bundle: true,
  format: "esm",
  outfile: resolve(jsOutdir, "milkdown.min.js"),
  minify: !watching,
  sourcemap: watching,
  target: ["es2022"],
  // Host app provides Stimulus via its own importmap pin
  external: ["@hotwired/stimulus"],
  logLevel: "info",
}

// Build CSS bundle (Crepe theme + fonts)
// Font files are output alongside the CSS. Propshaft's CssAssetUrls
// compiler rewrites the relative url() references at serve time.
const cssBuild = {
  entryPoints: [resolve(__dirname, "src/milkdown.css")],
  bundle: true,
  outdir: cssOutdir,
  minify: !watching,
  loader: {
    ".woff": "file",
    ".woff2": "file",
    ".ttf": "file",
    ".eot": "file",
  },
  assetNames: "fonts/[name]",
  logLevel: "info",
}

if (watching) {
  const jsCtx = await esbuild.context(jsBuild)
  const cssCtx = await esbuild.context(cssBuild)
  await jsCtx.watch()
  await cssCtx.watch()
  console.log("Watching for changes...")
} else {
  await Promise.all([esbuild.build(jsBuild), esbuild.build(cssBuild)])
}
