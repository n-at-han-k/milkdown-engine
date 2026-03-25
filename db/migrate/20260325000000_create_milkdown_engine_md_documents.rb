# frozen_string_literal: true

class CreateMilkdownEngineMdDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :milkdown_engine_md_documents do |t|
      t.string :title
      t.jsonb :content, null: false,
        default: { type: "doc", content: [{ type: "paragraph" }] }
      t.timestamps
    end

    add_index :milkdown_engine_md_documents, :content,
      using: :gin, opclass: :jsonb_path_ops,
      name: "idx_md_documents_content_path"
  end
end
