class FonctionnementsController < ApplicationController
  before_action :set_fonctionnement, only: %i[ show edit update destroy ]
  layout 'dashboard'
  # GET /fonctionnements or /fonctionnements.json
  def index
    if current_user.role == 'tractoriste'
      @fonctionnements = Fonctionnement.where(user_id: current_user.id)
    else
      @fonctionnements = Fonctionnement.all
    end
   
  end

  # GET /fonctionnements/1 or /fonctionnements/1.json
  def show
  end

  # GET /fonctionnements/new
  def new
    @fonctionnement = Fonctionnement.new
  @fonctionnement.depenses.build # Crée une dépense vide par défaut
  end

  # GET /fonctionnements/1/edit
  def edit
  end

  # POST /fonctionnements or /fonctionnements.json
  def create
    @fonctionnement = Fonctionnement.new(fonctionnement_params)

    respond_to do |format|
      if @fonctionnement.save
        format.html { redirect_to @fonctionnement, notice: "Fonctionnement was successfully created." }
        format.json { render :show, status: :created, location: @fonctionnement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fonctionnement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fonctionnements/1 or /fonctionnements/1.json
  def update
    respond_to do |format|
      if @fonctionnement.update(fonctionnement_params)
        format.html { redirect_to @fonctionnement, notice: "Fonctionnement was successfully updated." }
        format.json { render :show, status: :ok, location: @fonctionnement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fonctionnement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fonctionnements/1 or /fonctionnements/1.json
  def destroy
    @fonctionnement.destroy!

    respond_to do |format|
      format.html { redirect_to fonctionnements_path, status: :see_other, notice: "Fonctionnement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fonctionnement
      @fonctionnement = Fonctionnement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fonctionnement_params
      params.require(:fonctionnement).permit(
        :user_id,
        :tractor_id,
        :campagne,
        :cout_unitaire,
        :total_depense,
        depenses_attributes: [:id, :intitule, :quantite, :cout_unitaire, :montant_total, :_destroy]
      )
    end
    
end
