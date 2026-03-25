class DocumentsController < ApplicationController
  before_action :set_document, only: %i[show edit update destroy]

  def index
    @documents = MilkdownEngine::MdDocument.order(updated_at: :desc)
  end

  def new
    @document = MilkdownEngine::MdDocument.new
  end

  def create
    @document = MilkdownEngine::MdDocument.new(document_params)

    if @document.save
      redirect_to document_path(@document), notice: "Document created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @document.update(document_params)
      redirect_to document_path(@document), notice: "Document updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_path, notice: "Document deleted."
  end

  private

  def set_document
    @document = MilkdownEngine::MdDocument.find(params[:id])
  end

  def document_params
    params.require(:md_document).permit!.tap do |p|
      # The hidden input sends content as a JSON string — parse it back into a Hash
      # so ActiveRecord stores it properly in the jsonb column.
      p[:content] = JSON.parse(p[:content]) if p[:content].is_a?(String)
    end
  end
end
