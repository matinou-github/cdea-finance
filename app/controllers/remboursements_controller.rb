class RemboursementsController < ApplicationController
  before_action :set_remboursement, only: %i[ show edit update destroy ]
 layout 'dashboard'
  # GET /remboursements or /remboursements.json
  def index
    if current_user.role == "agriculteur"
      @remboursements = Remboursement.where(user_id: current_user.id).page(params[:page]).per(10).order(created_at: :desc)
    elsif current_user.role == "technicien"
      # Trouver les utilisateurs associés au technicien courant
      user_ids = User.where(commune: current_user.commune, village: current_user.village).pluck(:id)

      # Récupérer les demandes de service de ces utilisateurs
      @remboursements = Remboursement.where(user_id: user_ids).page(params[:page]).per(10).order(created_at: :desc)
    else
      @remboursements = Remboursement.page(params[:page]).per(10).order(created_at: :desc)
    end
  end

  # GET /remboursements/1 or /remboursements/1.json
  def show
  end

  # GET /remboursements/new
  def new
    @remboursement = Remboursement.new
    @remboursement.remboursement_details.build
  end

  # GET /remboursements/1/edit
  def edit
    @remboursement.remboursement_details.build if @remboursement.remboursement_details.empty?
  end

  # POST /remboursements or /remboursements.json
  def create
    @remboursement = Remboursement.new(remboursement_params)
    @remboursement.credite_par = current_user
    respond_to do |format|
      if @remboursement.save
        if @remboursement.type_remboursement == "Remb/mais"
          format.html { redirect_to balances_path, notice: "Remboursement was successfully created." }
        else
        format.html { redirect_to remboursements_path, notice: "Remboursement was successfully created." }
        format.json { render :show, status: :created, location: @remboursement }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @remboursement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /remboursements/1 or /remboursements/1.json
  def update
    respond_to do |format|
      if @remboursement.update(remboursement_params)
        format.html { redirect_to remboursements_path, notice: "Remboursement was successfully updated." }
        format.json { render :show, status: :ok, location: @remboursement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @remboursement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /remboursements/1 or /remboursements/1.json
  def destroy
    @remboursement.destroy!

    respond_to do |format|
      format.html { redirect_to remboursements_path, status: :see_other, notice: "Remboursement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_remboursement
      @remboursement = Remboursement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def remboursement_params
      params.require(:remboursement).permit(:user_id, :type_remboursement, :valeurs, :credite_par_id, :year, :mais_recuperer, remboursement_details_attributes: [:id, :sac, :valeur_kg, :_destroy, :valeurs_field])
    end
end
