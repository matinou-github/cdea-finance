class HerbicidesController < ApplicationController
  before_action :set_herbicide, only: %i[ show edit update destroy ]
  layout 'dashboard'
  # GET /herbicides or /herbicides.json
  def index
    @herbicides = Herbicide.all
  end

  # GET /herbicides/1 or /herbicides/1.json
  def show
  end

  # GET /herbicides/new
  def new
    @herbicide = Herbicide.new
  end

  # GET /herbicides/1/edit
  def edit
  end

  # POST /herbicides or /herbicides.json
  def create
    @herbicide = Herbicide.new(herbicide_params)

    respond_to do |format|
      if @herbicide.save
        format.html { redirect_to herbicides_path, notice: "Herbicide was successfully created." }
        format.json { render :show, status: :created, location: @herbicide }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @herbicide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /herbicides/1 or /herbicides/1.json
  def update
    respond_to do |format|
      if @herbicide.update(herbicide_params)
        format.html { redirect_to herbicides_path, notice: "Herbicide was successfully updated." }
        format.json { render :show, status: :ok, location: @herbicide }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @herbicide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /herbicides/1 or /herbicides/1.json
  def destroy
    @herbicide.destroy!

    respond_to do |format|
      format.html { redirect_to herbicides_path, status: :see_other, notice: "Herbicide was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_herbicide
      @herbicide = Herbicide.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def herbicide_params
      params.require(:herbicide).permit(:nom, :prix, :garantie_par_litre, :soja_par_litre)
    end
end
