class VillageSettingsController < ApplicationController
  before_action :set_village_setting, only: %i[ show edit update destroy ]

  # GET /village_settings or /village_settings.json
  def index
    @village_settings = VillageSetting.all
  end

  # GET /village_settings/1 or /village_settings/1.json
  def show
  end

  # GET /village_settings/new
  def new
    @village_setting = VillageSetting.new
  end

  # GET /village_settings/1/edit
  def edit
  end

  # POST /village_settings or /village_settings.json
  def create
    @village_setting = VillageSetting.new(village_setting_params)

    respond_to do |format|
      if @village_setting.save
        format.html { redirect_to indice_setting_path, notice: "Village setting was successfully created." }
        format.json { render :show, status: :created, location: @village_setting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @village_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /village_settings/1 or /village_settings/1.json
  def update
    respond_to do |format|
      if @village_setting.update(village_setting_params)
        format.html { redirect_to indice_setting_path, notice: "Village setting was successfully updated." }
        format.json { render :show, status: :ok, location: @village_setting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @village_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /village_settings/1 or /village_settings/1.json
  def destroy
    @village_setting.destroy!

    respond_to do |format|
      format.html { redirect_to village_settings_path, status: :see_other, notice: "Village setting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_village_setting
      @village_setting = VillageSetting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def village_setting_params
      params.require(:village_setting).permit(:village, :kg_ha_labouree)
    end
end
