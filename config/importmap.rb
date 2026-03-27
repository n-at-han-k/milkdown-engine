# frozen_string_literal: true

# Vendored Milkdown bundle (built by esbuild from src/)
pin "milkdown_engine/milkdown", to: "milkdown_engine/milkdown.min.js"

# Vendored dependencies
pin "@stimulus-components/auto-submit", to: "@stimulus-components--auto-submit.js"

# MilkdownEngine Stimulus controllers
pin_all_from MilkdownEngine::Engine.root.join("app/javascript/milkdown_engine/controllers"),
  under: "controllers/milkdown_engine", to: "milkdown_engine/controllers"
