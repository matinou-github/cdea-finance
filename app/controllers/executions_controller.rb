class ExecutionsController < ApplicationController
  before_action :set_execution, only: %i[ show edit update destroy]
  layout 'dashboard'
  # GET /executions or /executions.json
  def index
    
    if current_user.role == "technicien"
      @executions = Execution.includes(machines: :tractor).where(user_id: current_user.id).page(params[:page]).per(10).order(created_at: :desc)
    else
      @executions = Execution.includes(machines: :tractor).order(created_at: :desc)
      #@executions = @executions.joins(:machines).where('LOWER(machines.machine_info) LIKE LOWER(?)', "%#{params[:machine_info].downcase}%") if params[:machine_info].present?
      @executions = @executions.where(year: params[:year]) if params[:year].present?
      @executions = @executions.page(params[:page]).per(10)
       # Calcul de la somme de la superficie
      @total_superficie = @executions.sum(:superficie)
    end

  end

  # GET /executions/1 or /executions/1.json
  def show
  end

  # GET /executions/new
  def new
    @execution = Execution.new
    @execution.machines.build 
    @demandes_validees = ServiceRequest.where(status_request: "execute")
  end

  # GET /executions/1/edit
  def edit
    @demandes_validees = ServiceRequest.where(status_request: "execute")
  end

  # POST /executions or /executions.json
  def create
    #@execution = Execution.new(execution_params)
    @execution = Execution.new(execution_params)
    Rails.logger.debug "PARAMS: #{execution_params.inspect}"
    @execution.user_id = current_user.id
    @execution.machines.each do |machine|
      puts machine.tractor_id # Affiche le tractor_id de chaque machine
    end
    respond_to do |format|
      if @execution.save
          # Associer les herbicides après la création
      # params[:execution][:machines]&.each do |machine_params|
      #   Rails.logger.debug "Traitement de des machine : #{machine_params}"
      #   @execution.execution_machines.create(
      #     machine_id: machine_params[:id],
      #     tractor_id: machine_params[:tractor_id],
      #     superficie: machine_params[:superficie],
      #     preuve: machine_params[:preuve]
      #   )
        
      # end
        format.html { redirect_to executions_path, notice: "Execution was successfully created." }
        format.json { render :show, status: :created, location: @execution }
      else
        @execution.errors.full_messages.each do |message|
          puts message
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /executions/1 or /executions/1.json
  # def update
  #   @execution = Execution.find(params[:id])
  #   uploaded_file = params[:file] # Fichier téléversé
  #   service_id = params[:execution][:service_request_id]
  #   superficie = params[:execution][:superficie]
  
  #   begin
  #     # Mise à jour des informations texte
  #     @execution.update(
  #       service_request_id: service_id,
  #       superficie: superficie
  #     )
  
  #     if uploaded_file.present?
  #       Rails.logger.info "Fichier reçu pour mise à jour : #{uploaded_file.original_filename}"
  
  #       # Métadonnées pour le fichier
  #       file_metadata = {
  #         name: "execution_#{@execution.id}_preuve",
  #         parents: ['1r7lP6VfEEYeOLuaXa0DnWhJ5mfeSeXes'] # Dossier cible
  #       }
  
  #       # Téléversement du fichier vers Google Drive
  #       file = DRIVE_SERVICE.create_file(
  #         file_metadata,
  #         fields: 'id',
  #         upload_source: uploaded_file.tempfile,
  #         content_type: uploaded_file.content_type
  #       )
  
  #       # Définir les permissions pour rendre le fichier public
  #       DRIVE_SERVICE.create_permission(
  #         file.id,
  #         Google::Apis::DriveV3::Permission.new(
  #           type: 'anyone',
  #           role: 'reader'
  #         )
  #       )
  
  #       # Générer l'URL publique et mettre à jour la base de données
  #       url = "https://drive.google.com/uc?id=#{file.id}"
  #       @execution.update(preuve: url)
  
  #       Rails.logger.info "Fichier mis à jour avec succès : #{file.id}"
  #     end
  
  #     redirect_to executions_path, notice: 'Exécution mise à jour avec succès.'
  #   rescue Google::Apis::Error => e
  #     Rails.logger.error "Erreur Google Drive : #{e.message}"
  #     flash[:alert] = "Erreur lors de l'envoi à Google Drive."
  #     render :edit
  #   rescue => e
  #     Rails.logger.error "Erreur inattendue : #{e.message}"
  #     flash[:alert] = "Une erreur inattendue s'est produite."
  #     render :edit
  #   end
  # end
  def update
    respond_to do |format|
      if @execution.update(execution_params)
        format.html { redirect_to executions_path, notice: "execution was successfully updated." }
        format.json { render :show, status: :ok, location: @execution }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @execution.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /executions/1 or /executions/1.json
  def destroy
    @execution.destroy!

    respond_to do |format|
      format.html { redirect_to executions_path, status: :see_other, notice: "Execution was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def print_execution
    @executions = Execution.order(created_at: :desc)
      @executions = @executions.where('LOWER(machine_info) LIKE LOWER(?)', "%#{params[:machine_info].downcase}%") if params[:machine_info].present?
      @executions = @executions.where(year: params[:year]) if params[:year].present?
    @indice_setting = IndiceSetting.last
    @manager_name = @indice_setting.gerant_name
    @total_superficie = @executions.sum(:superficie)
    render layout: 'print' # Utiliser le layout d'impression
  end

  # def upload_identity_card
  #   uploaded_file = params[:file] # Récupération du fichier
  #   service_id = params[:service_request_id]
  #   superficie = params[:superficie]
  
  #   if uploaded_file.present?
  #     Rails.logger.info "Fichier reçu : #{uploaded_file.original_filename}"
  
  #     # Métadonnées pour le fichier
  #     file_metadata = {
  #       name: "execution_#{current_user.id}_preuve_#{SecureRandom.hex(8)}_preuve",
  #       parents: ['1r7lP6VfEEYeOLuaXa0DnWhJ5mfeSeXes'] # Dossier cible
  #     }
  
  #     # Téléversement du fichier vers Google Drive
  #     file = DRIVE_SERVICE.create_file(
  #       file_metadata,
  #       fields: 'id',
  #       upload_source: uploaded_file.tempfile,
  #       content_type: uploaded_file.content_type
  #     )
  
  #     # Définir les permissions pour rendre le fichier public
  #     DRIVE_SERVICE.create_permission(
  #       file.id,
  #       Google::Apis::DriveV3::Permission.new(
  #         type: 'anyone',
  #         role: 'reader'
  #       )
  #     )
  
  #     # Générer l'URL publique
  #     url = "https://drive.google.com/uc?id=#{file.id}"
  
  #     # Sauvegarder dans la base de données
  #     execution = Execution.create(
  #       service_request_id: service_id,
  #       superficie: superficie,
  #       preuve: url,
  #       user_id: current_user.id
  #     )
  
  #     if execution.persisted?
  #       Rails.logger.info "Exécution sauvegardée : #{execution.inspect}"
  #       redirect_to executions_path, notice: 'Fichier téléversé et exécution créée avec succès.'
  #     else
  #       Rails.logger.error "Erreur de validation : #{execution.errors.full_messages.join(', ')}"
  #       flash[:alert] = "Une erreur s'est produite : #{execution.errors.full_messages.join(', ')}"
  #       redirect_to new_execution_path
  #     end
  #   else
  #     flash[:alert] = 'Aucun fichier reçu.'
  #     redirect_to new_execution_path
  #   end
  # rescue Google::Apis::Error => e
  #   Rails.logger.error "Erreur Google Drive : #{e.message}"
  #   flash[:alert] = "Erreur lors de l'envoi à Google Drive."
  #   redirect_to new_execution_path
  # rescue => e
  #   Rails.logger.error "Erreur inattendue : #{e.message}"
  #   flash[:alert] = "Une erreur inattendue s'est produite."
  #   redirect_to new_execution_path
  # end
  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_execution
      @execution = Execution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    # def execution_params
    #   params.require(:execution).permit(:service_request_id, :superficie, :preuve, :user_id, :machine_info, :year)
    # end

    def execution_params
      params.require(:execution).permit(
        :service_request_id, :superficie, :year, 
        machines_attributes: [:id, :tractor_id, :superficie, :preuve, :year, :_destroy]
      )
    end
    
end
