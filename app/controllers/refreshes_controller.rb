class RefreshesController < ApplicationController
  before_action :set_refresh, only: [:show, :edit, :update, :destroy]

  # GET /refreshes
  # GET /refreshes.json
  def index
    @refreshes = Refresh.all
  end

  # GET /refreshes/1
  # GET /refreshes/1.json
  def show
  end

  # GET /refreshes/new
  def new
    @refresh = Refresh.new
  end

  # GET /refreshes/1/edit
  def edit
  end

  # POST /refreshes
  # POST /refreshes.json
  def create
    @refresh = Refresh.new(refresh_params)

    respond_to do |format|
      if @refresh.save
        format.html { redirect_to @refresh, notice: 'Refresh was successfully created.' }
        format.json { render action: 'show', status: :created, location: @refresh }
      else
        format.html { render action: 'new' }
        format.json { render json: @refresh.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /refreshes/1
  # PATCH/PUT /refreshes/1.json
  def update
    respond_to do |format|
      if @refresh.update(refresh_params)
        format.html { redirect_to @refresh, notice: 'Refresh was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @refresh.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /refreshes/1
  # DELETE /refreshes/1.json
  def destroy
    @refresh.destroy
    respond_to do |format|
      format.html { redirect_to refreshes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_refresh
      @refresh = Refresh.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def refresh_params
      params.require(:refresh).permit(:user_id, :repo_id, :exercise_id, :logged_at)
    end
end
