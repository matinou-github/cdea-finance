class RestitutionsController < ApplicationController
  before_action :set_restitution, only: %i[ show edit update destroy ]
  layout 'dashboard'
  # GET /restitutions or /restitutions.json
  def index
    if current_user.role == "agriculteur"
      @restitutions = Restitution.where(user_id: current_user.id).page(params[:page]).per(10).order(created_at: :desc)
    else
      @restitutions = Restitution.order(created_at: :asc)
      @restitutions =  @restitutions.where(year: params[:year]) if params[:year].present?
      if params[:village].present?
        village_term = "%#{params[:village]}%"
        @restitutions = @restitutions.joins(:user).where("users.village ILIKE :village", village: village_term)
      end
      @restitutions = @restitutions.page(params[:page]).per(10).order(created_at: :desc)
    end
    @year = params[:year]
  end

  # GET /restitutions/1 or /restitutions/1.json
  def show
  end

  # GET /restitutions/new
  def new
    @restitution = Restitution.new
  end

  # GET /restitutions/1/edit
  def edit
  end

  # POST /restitutions or /restitutions.json
  def create
    @restitution = Restitution.new(restitution_params)

    respond_to do |format|
      if @restitution.save
        balance_request = Balance.find_by(:user_id=> @restitution.user_id, :year =>  @restitution.year)
        balance_request.update!(total_garantie: balance_request.total_garantie -  @restitution.garantie, etat_garantie: "Restituée")
        format.html { redirect_to balances_path, notice: "Restitution was successfully created." }
        format.json { render :show, status: :created, location: @restitution }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @restitution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restitutions/1 or /restitutions/1.json
  def update
    respond_to do |format|
      if @restitution.update(restitution_params)
        format.html { redirect_to restitutions_path, notice: "Restitution was successfully updated." }
        format.json { render :show, status: :ok, location: @restitution }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @restitution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restitutions/1 or /restitutions/1.json
  def destroy
    @restitution.destroy!

    respond_to do |format|
      format.html { redirect_to restitutions_path, status: :see_other, notice: "Restitution was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def print_restitution
    @restitutions = Restitution.order(created_at: :asc)
    @restitutions =  @restitutions.where(year: params[:year]) if params[:year].present?
    if params[:village].present?
      village_term = "%#{params[:village]}%"
      @restitutions = @restitutions.joins(:user).where("users.village ILIKE :village", village: village_term)
    end
    @indice_setting = IndiceSetting.last
    @manager_name = @indice_setting.gerant_name
    render layout: 'print' # Utiliser le layout d'impression
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restitution
      @restitution = Restitution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def restitution_params
      params.require(:restitution).permit(:garantie, :year, :user_id, :restitué_par)
    end
end
