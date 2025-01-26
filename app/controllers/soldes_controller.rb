class SoldesController < ApplicationController
  before_action :set_solde, only: %i[ show edit update destroy ]
  layout 'dashboard'
  # GET /soldes or /soldes.json
  def index
    @soldes = Solde.all
  end

  # GET /soldes/1 or /soldes/1.json
  def show
  end

  # GET /soldes/new
  def new
    @solde = Solde.new
  end

  # GET /soldes/1/edit
  def edit
  end

  # POST /soldes or /soldes.json
  def create
    @solde = Solde.new(solde_params)

    respond_to do |format|
      if @solde.save
        format.html { redirect_to @solde, notice: "Solde was successfully created." }
        format.json { render :show, status: :created, location: @solde }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @solde.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /soldes/1 or /soldes/1.json
  def update
    respond_to do |format|
      if @solde.update(solde_params)
        format.html { redirect_to @solde, notice: "Solde was successfully updated." }
        format.json { render :show, status: :ok, location: @solde }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @solde.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /soldes/1 or /soldes/1.json
  def destroy
    @solde.destroy!

    respond_to do |format|
      format.html { redirect_to soldes_path, status: :see_other, notice: "Solde was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def fetch_tractor_data
    tractor_id = params[:tractor_id]
    campagne = params[:campagne]

    if tractor_id.present? && campagne.present?
      # Jointure pour accéder au tractor_id via machines
      superficie_labouree = Machine.where(tractor_id: tractor_id, year: campagne).sum(:superficie)
      # Calcul des dépenses en utilisant le même principe
      depenses = Fonctionnement.where(tractor_id: tractor_id, campagne: campagne).sum(:total_depense)

      # Renvoyer les données sous forme JSON
      render json: {
        superficie_labouree: superficie_labouree,
        depenses: depenses
      }
    else
      render json: { error: "Paramètres manquants" }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solde
      @solde = Solde.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def solde_params
      params.require(:solde).permit(:campagne, :user_id, :tractor_id, :cout_unitaire, :superficie_labouree, :montant_prestation, :solde_total, :depenses)
    end
end
