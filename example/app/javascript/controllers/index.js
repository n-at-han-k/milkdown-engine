import { application } from "controllers/application"

// Eager-load controllers from the host app
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Eager-load controllers from the milkdown_engine engine
eagerLoadControllersFrom("controllers/milkdown_engine", application)
