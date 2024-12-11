class RemboursementsController < ApplicationController
  before_action :set_remboursement, only: %i[ show edit update destroy ]
 layout 'dashboard'
  # GET /remboursements or /remboursements.json
  def index
    @remboursements = Remboursement.page(params[:page]).per(10).order(created_at: :desc)
  end

  # GET /remboursements/1 or /remboursements/1.json
  def show
  end

  # GET /remboursements/new
  def new
    @remboursement = Remboursement.new
  end

  # GET /remboursements/1/edit
  def edit
  end

  # POST /remboursements or /remboursements.json
  def create
    @remboursement = Remboursement.new(remboursement_params)
    @remboursement.credite_par = current_user
    respond_to do |format|
      if @remboursement.save
        format.html { redirect_to remboursements_path, notice: "Remboursement was successfully created." }
        format.json { render :show, status: :created, location: @remboursement }
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
        format.html { redirect_to @remboursement, notice: "Remboursement was successfully updated." }
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
      params.require(:remboursement).permit(:user_id, :type_remboursement, :valeurs, :credite_par_id, :service_request_id)
    end
end
