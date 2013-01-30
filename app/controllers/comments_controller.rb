class CommentsController < ApplicationController

  respond_to  :html
  respond_to  :json, :except => [ :new, :edit ]

  before_filter :set_up_section
  before_filter :find_record
  before_filter :find_entry
  before_filter :find_comment, only: [:show, :edit, :update, :delete]

  # GET /record/:record_id/:section_name/:entry_id/comments
  # GET /record/:record_id/:section_name/:entry_id/comments.json
  
  def index
    @comments = @entry.comments
    respond_with(@comments)
  end

  # GET /record/:record_id/:section_name/:entry_id/comments/:id
  # GET /record/:record_id/:section_name/:entry_id/comments/:id.json
  
  def show
    respond_with(@comment)
  end

  # GET /record/:record_id/:section_name/:entry_id/comments/new

  def new
    @comment = Comment.new
  end

  # POST /record/:record_id/:section_name/:entry_id/comments
  # POST /record/:record_id/:section_name/:entry_id/comments.json

  def create
    comment = Comment.new(params[:comment])
    @entry.comments << comment if comment.valid?
    respond_with(comment, location: redirect_to_index)
  end

  # GET /record/:record_id/:section_name/:entry_id/comments/:id/edit

  def edit
  end

  # PUT /record/:record_id/:section_name/:entry_id/comments/:id
  # PUT /record/:record_id/:section_name/:entry_id/comments/:id.json

  def update
    @comment.update_attributes(params[:comment])
    respond_with(@comment, location: redirect_to_index)
  end

  # DELETE /record/:record_id/:section_name/:entry_id/comments/:id
  # DELETE /record/:record_id/:section_name/:entry_id/comments/:id.json
  
  def destroy
    @comment.destroy
    respond_with(@comment, location: redirect_to_index)
  end

  private

  def set_up_section
    @section_name = params[:section]
    sr = SectionRegistry.instance
    @extension = sr.extension_from_path(params[:section])
    unless @extension
      render text: 'Section Not Found', status: 404
    end
  end
  
  def find_entry
    if Moped::BSON::ObjectId.legal?(params[:entry_id])
      @entry = @record.send(@section_name).where(id: params[:entry_id]).first
      raise RequestError.new(404, 'Entry Not Found') unless @entry
    else
      raise RequestError.new(404, 'Entry Not Found')
    end
  end

  def find_comment
    if Moped::BSON::ObjectId.legal?(params[:id])
      @comment = @entry.comments.where(id: params[:id]).first
      raise RequestError.new(404, 'Comment Not Found') unless @comment
    else
      raise RequestError.new(404, 'Comment Not Found')
    end
  end

  def redirect_to_index
    section_document_comments_path(@record.medical_record_number, @section_name, @entry)
  end

end
