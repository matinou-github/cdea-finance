class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'
  before_action :set_service_request, only: %i[ show edit update destroy ]

  # GET /service_requests or /service_requests.json
  def index
    @service_requests = ServiceRequest.all
  end

  # GET /service_requests/1 or /service_requests/1.json
  def show
    @service_request = ServiceRequest.find(params[:id])
    @service_request_amount = @service_request.garantie.to_i
  end

  # GET /service_requests/new
  def new
    @indice_setting = IndiceSetting.last
    @frais_dossier = @indice_setting.frais_dossier
    @garantie_ha = @indice_setting.garantie_ha
    @garantie_litre = @indice_setting.garantie_litre
    @service_request = ServiceRequest.new
  end

  # GET /service_requests/1/edit
  def edit
    @indice_setting = IndiceSetting.last
    @frais_dossier = @indice_setting.frais_dossier
    @garantie_ha = @indice_setting.garantie_ha
    @garantie_litre = @indice_setting.garantie_litre
  end

  # POST /service_requests or /service_requests.json
  def create
     logger.debug "Service request params: #{params.inspect}"
    @service_request = ServiceRequest.new(service_request_params)
    # Sauvegarder avec user_id
    @service_request.user_id = current_user.id  # Assurez-vous d'être authentifié avec Devise

    if @service_request.save
      redirect_to @service_request, notice: 'Demande de service enregistrée avec succès.'
    else
      render :new
    end
  end

  # PATCH/PUT /service_requests/1 or /service_requests/1.json
  def update
    respond_to do |format|
      if @service_request.update(service_request_params)
        format.html { redirect_to service_requests_path, notice: "Service request was successfully updated." }
        format.json { render :show, status: :ok, location: @service_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_requests/1 or /service_requests/1.json
  def destroy
    @service_request.destroy!

    respond_to do |format|
      format.html { redirect_to service_requests_path, status: :see_other, notice: "Service request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def service_payement
    @service_request = ServiceRequest.find(params[:id])

    transaction = FedaPay::Transaction.retrieve(params[:'transaction-id'])
    if transaction.status == 'approved'
      paid = { paye: true, mode: transaction.mode, date_approved: transaction.approved_at, montant: transaction.amount}
      @service_request.update(status: "paid")
  
      redirect_to service_requests_path
      flash[:success] = "Souscription faites avec succès."
    else
      redirect_to service_request_url(@service_request)
      flash[:error] = "Erreur lors de la souscription; veillez reessayer svp"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_request
      @service_request = ServiceRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_request_params
      params.require(:service_request).permit(:user_id, :superficie, :herbicide_nom, :herbicide_prix, :herbicide_quantite, :garantie, :herbicide_id, :preuve, :status, :status_request, :kg_paye)
    end
end
