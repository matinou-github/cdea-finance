class TractorsController < ApplicationController
  before_action :set_tractor, only: %i[ show edit update destroy ]
  before_action :authenticate_user! # Assure que seuls les utilisateurs authentifiés peuvent accéder à cette page
  layout 'dashboard'
  def index
    # Recherche de tracteurs en fonction du nom ou du propriétaire
    @tractors = Tractor.includes(:user) # Optimise les requêtes pour éviter N+1

    if params[:q].present?
      @tractors = @tractors.where("tractors.name ILIKE :query OR users.nom ILIKE :query OR users.prenom ILIKE :query", query: "%#{params[:q]}%")
                           .references(:users)
    end

    @tractors = @tractors.order(created_at: :desc).page(params[:page]).per(10) # Ajoute la pagination
  end

  # GET /tractors/1 or /tractors/1.json
  def show
  end

  # GET /tractors/new
  def new
    @tractor = Tractor.new
  end

  # GET /tractors/1/edit
  def edit
  end

  # POST /tractors or /tractors.json
  def create
    @tractor = Tractor.new(tractor_params)
    @tractor.user_id = current_user.id unless current_user.admin?
    respond_to do |format|
      if @tractor.save
        format.html { redirect_to tractors_path, notice: "Tractor was successfully created." }
        format.json { render :show, status: :created, location: @tractor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tractor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tractors/1 or /tractors/1.json
  def update
    respond_to do |format|
      if @tractor.update(tractor_params)
        format.html { redirect_to @tractor, notice: "Tractor was successfully updated." }
        format.json { render :show, status: :ok, location: @tractor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tractor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tractors/1 or /tractors/1.json
  def destroy
    @tractor.destroy!

    respond_to do |format|
      format.html { redirect_to tractors_path, status: :see_other, notice: "Tractor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tractor
      @tractor = Tractor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tractor_params
      params.require(:tractor).permit(:name, :user_id)
    end
end
