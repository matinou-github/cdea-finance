class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show edit update destroy ]
  layout 'dashboard'
  # GET /stocks or /stocks.json
  def index
    if current_user.role == "agriculteur"
      @stocks = Stock.where(user_id: current_user.id).page(params[:page]).per(10).order(created_at: :desc)
    elsif current_user.role == "technicien"
      # Trouver les utilisateurs associés au technicien courant
      user_ids = User.where(commune: current_user.commune, village: current_user.village).pluck(:id)

      # Récupérer les demandes de service de ces utilisateurs
      @stocks = Stock.where(user_id: user_ids).page(params[:page]).per(10).order(created_at: :desc)
    else
      @stocks = Stock.page(params[:page]).per(10).order(created_at: :desc)
    end
  end

  # GET /stocks/1 or /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks or /stocks.json
  def create
    @stock = Stock.new(stock_params)
    p params[:stock][:save_by]
    respond_to do |format|
      if @stock.save
        format.html { redirect_to stocks_path, notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to stocks_path, notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    @stock.destroy!

    respond_to do |format|
      format.html { redirect_to stocks_path, status: :see_other, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:debit, :credit, :valeur, :produit, :save_by, :user_id)
    end
end
