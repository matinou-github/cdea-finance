class ExecutionsController < ApplicationController
  before_action :set_execution, only: %i[ show edit update destroy ]
  layout 'dashboard'
  # GET /executions or /executions.json
  def index
    @executions = Execution.page(params[:page]).per(10).order(created_at: :desc)
  end

  # GET /executions/1 or /executions/1.json
  def show
  end

  # GET /executions/new
  def new
    @execution = Execution.new
  end

  # GET /executions/1/edit
  def edit
  end

  # POST /executions or /executions.json
  def create
    @execution = Execution.new(execution_params)
    @execution.user_id = current_user.id
    respond_to do |format|
      if @execution.save
        format.html { redirect_to @execution, notice: "Execution was successfully created." }
        format.json { render :show, status: :created, location: @execution }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /executions/1 or /executions/1.json
  def update
    respond_to do |format|
      if @execution.update(execution_params)
        format.html { redirect_to @execution, notice: "Execution was successfully updated." }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_execution
      @execution = Execution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def execution_params
      params.require(:execution).permit(:service_request_id, :superficie, :preuve, :userid)
    end
end
