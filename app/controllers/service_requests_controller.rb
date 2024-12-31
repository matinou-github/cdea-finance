class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'
  before_action :set_service_request, only: %i[ show edit update destroy update_status]

  # GET /service_requests or /service_requests.json
  def index
    if current_user.role == "agriculteur"
      @service_requests = ServiceRequest.includes(service_request_herbicides: :herbicide).where(user_id: current_user.id).page(params[:page]).per(10).order(created_at: :desc)
    else
      @service_requests = ServiceRequest.includes(:user, service_request_herbicides: :herbicide).page(params[:page]).per(10).order(created_at: :desc)
    end
  end

  # GET /service_requests/1 or /service_requests/1.json
  def show
    @service_request = ServiceRequest.find(params[:id])
    @service_request_amount = @service_request.garantie.to_i
    @indice_setting = IndiceSetting.last
    @frais_dossier = @indice_setting.frais_dossier
    respond_to do |format|
      format.html # Rend la vue 'show.html.erb'
      format.json { render json: { superficie: @service_request.superficie } }
    end
  end

  # GET /service_requests/new
  def new
    @indice_setting = IndiceSetting.last
    @frais_dossier = @indice_setting.frais_dossier
    @garantie_ha = @indice_setting.garantie_ha
    @garantie_litre = @indice_setting.garantie_litre
    @kg_ha_laboure = @indice_setting.kg_ha_laboure
    @kg_litre_octroie = @indice_setting.kg_litre_octroi
    @service_request = ServiceRequest.new
    @service_request.service_request_herbicides.build
  end

  # GET /service_requests/1/edit
  def edit
    @indice_setting = IndiceSetting.last
    @frais_dossier = @indice_setting.frais_dossier
    @garantie_ha = @indice_setting.garantie_ha
    @garantie_litre = @indice_setting.garantie_litre
    @kg_ha_laboure = @indice_setting.kg_ha_laboure
    @kg_litre_octroie = @indice_setting.kg_litre_octroi
    @service_request = ServiceRequest.find(params[:id])
    @herbicides = @service_request.service_request_herbicides.includes(:herbicide) || [] 
    #service_request.service_request_herbicides
    @all_herbicides = Herbicide.all
  end

  # POST /service_requests or /service_requests.json


  def create
    @service_request = ServiceRequest.new(service_request_params.except(:herbicides))
    @service_request.user_id = current_user.id 
    if @service_request.save
      # Associer les herbicides après la création
      params[:service_request][:herbicides]&.each do |herbicide_params|
        Rails.logger.debug "Traitement de l'herbicide : #{herbicide_params}"
        @service_request.service_request_herbicides.create(
          herbicide_id: herbicide_params[:id],
          quantite: herbicide_params[:quantite]
        )
        
      end
  
      redirect_to @service_request, notice: 'Demande créée avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  

  # PATCH/PUT /service_requests/1 or /service_requests/1.json
  def update
    respond_to do |format|
      if @service_request.update(service_request_params.except(:herbicides))

      if params[:service_request][:herbicides]
        @service_request.service_request_herbicides.destroy_all # Supprime les anciennes associations
        
        params[:service_request][:herbicides].each do |herbicide_params|
          @service_request.service_request_herbicides.create(
            herbicide_id: herbicide_params[:id],
            quantite: herbicide_params[:quantite]
          )
        end
      end
        format.html { redirect_to @service_request, notice: "Service request was successfully updated." }
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
  
      redirect_to dashboard_success_payment_path(demande_id: @service_request)
      flash[:success] = "Souscription faites avec succès."
    else
      redirect_to @service_request
      flash[:error] = "Erreur lors de la souscription; veillez reessayer svp"
    end
  end

  def convertir_garantie
    service_request = ServiceRequest.find(params[:id])
    @indice_setting = IndiceSetting.last
    @valeur_soja = @indice_setting.valeur_soja
  
    kg_to_convert = params[:kg_to_convert].to_f
    guarantee_to_deduct = params[:guarantee_to_deduct].to_f
  
    if service_request.garantie.to_f >= guarantee_to_deduct
      Remboursement.create!(
        user: service_request.user,
        service_request: service_request,
        type_remboursement: "nature",
        valeurs: kg_to_convert,
        credite_par: current_user
      )
  
      service_request.update!(garantie: service_request.garantie.to_f - guarantee_to_deduct)
  
      flash[:success] = "Garantie convertie avec succès en #{kg_to_convert} kg de soja."
    else
      flash[:error] = "Garantie insuffisante pour effectuer cette conversion."
    end
  
    redirect_to dashboard_bilan_path
  end

  def update_status
    if @service_request.update(status_request: params[:service_request][:status_request])
      redirect_to service_requests_path
      
    else
      render json: { message: "Erreur lors de la mise à jour du statut." }, status: :unprocessable_entity
    end
  end

  def payement_direct
    @service_request = ServiceRequest.find(params[:id])
    @service_request.update(status: "paid", recu_par: current_user.full_name)
    redirect_to @service_request
    flash[:success] = "Souscription faites avec succès"
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_request
      @service_request = ServiceRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_request_params
      params.require(:service_request).permit(
        :superficie, 
        :garantie, 
        :kg_paye, 
        :status, 
        :recu_par,
        :status_request, 
        herbicides: [:id, :quantite]
      )
    end

    
end
