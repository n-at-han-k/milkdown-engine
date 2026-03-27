# frozen_string_literal: true

require "ui"

module MilkdownEngine
  class Engine < ::Rails::Engine
    isolate_namespace MilkdownEngine

    initializer "milkdown_engine.dependencies" do
      require "acts-as-taggable-on"
      require "ransack"
    end

    # Register importmap pins for Stimulus controllers
    initializer "milkdown_engine.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << Engine.root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << Engine.root.join("app/javascript")
      end
    end

    # Add engine assets to the asset load path (for propshaft/sprockets)
    initializer "milkdown_engine.assets" do |app|
      app.config.assets.paths << Engine.root.join("app/assets/javascripts")
      app.config.assets.paths << Engine.root.join("app/assets/stylesheets")

      # Stimulus controllers live under app/javascript/ — add it so
      # importmap pin_all_from URLs resolve through the asset pipeline.
      app.config.assets.paths << Engine.root.join("app/javascript")

      # Vendored JS packages
      app.config.assets.paths << Engine.root.join("vendor/javascript")

      # rails-active-ui ships stylesheets.css directly in app/assets/
      app.config.assets.paths << Ui::Engine.root.join("app/assets")
    end

    # Append engine migrations so host apps pick them up without copying
    initializer "milkdown_engine.migrations", after: :load_config_initializers do |app|
      unless app.root.to_s == root.to_s
        engine_migrate_path = root.join("db/migrate").to_s
        app.config.paths["db/migrate"] << engine_migrate_path
        ActiveRecord::Migrator.migrations_paths << engine_migrate_path
      end
    end

    # Make engine helpers available in host app views
    initializer "milkdown_engine.helpers" do
      ActiveSupport.on_load(:action_view) do
        include MilkdownEngine::ApplicationHelper
      end
    end
  end
end
