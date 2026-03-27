# frozen_string_literal: true

class RenameMdDocumentsToDocuments < ActiveRecord::Migration[8.1]
  def change
    rename_table :milkdown_engine_md_documents, :milkdown_engine_documents
  end
end
