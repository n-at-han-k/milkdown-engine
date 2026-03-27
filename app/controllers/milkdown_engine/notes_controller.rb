# frozen_string_literal: true

module MilkdownEngine
  class NotesController < ApplicationController
    before_action :set_notes
    before_action :set_note, only: %i[show edit update destroy]

    def index
      @note = @notes.first || Document.new
    end

    def show; end

    def new
      @note = Document.new
    end

    def create
      @note = Document.new(note_params)
      if @note.save
        redirect_to note_path(@note), notice: "Note was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @note.update(note_params)
        respond_to do |format|
          format.turbo_stream { head :ok }
          format.html { redirect_to note_path(@note), notice: "Note was successfully updated." }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @note.destroy!
      redirect_to notes_path, notice: "Note was successfully deleted."
    end

    private

    def set_notes
      @q = Document.ransack(params[:q])
      @notes = @q.result.order(updated_at: :desc)
    end

    def set_note
      @note = Document.find(params[:id])
    end

    def note_params
      params.require(:document).permit(:title, :content).tap do |p|
        p[:content] = JSON.parse(p[:content]) if p[:content].is_a?(String)
      end
    end
  end
end
