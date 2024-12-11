class ZoneAssignmentsController < ApplicationController
  before_action :set_zone_assignment, only: %i[ show edit update destroy ]
  layout 'dashboard'
  # GET /zone_assignments or /zone_assignments.json
  def index
    @users = User.where(role: 'agriculteur')
    @zone_assignments = ZoneAssignment.page(params[:page]).per(10).order(created_at: :desc)
  end

  # GET /zone_assignments/1 or /zone_assignments/1.json
  def show
  end

  # GET /zone_assignments/new
  def new
    @users = User.where(role: 'agriculteur')
    @zone_assignment = ZoneAssignment.new
  end

  # GET /zone_assignments/1/edit
  def edit
    @users = User.where(role: 'agriculteur')
  end

  # POST /zone_assignments or /zone_assignments.json
  def create
    @zone_assignment = ZoneAssignment.new(zone_assignment_params)
    @zone_assignment.assigned_by_id = current_user.id

    respond_to do |format|
      if @zone_assignment.save
        format.html { redirect_to zone_assignments_path, notice: "Zone assignment was successfully created." }
        format.json { render :show, status: :created, location: @zone_assignment }
      else
        @users = User.where(role: 'agriculteur')
        render :new, alert: "Une erreur s'est produite."
      end
    end
  end

  # PATCH/PUT /zone_assignments/1 or /zone_assignments/1.json
  def update
    respond_to do |format|
      if @zone_assignment.update(zone_assignment_params)
        format.html { redirect_to @zone_assignment, notice: "Zone assignment was successfully updated." }
        format.json { render :show, status: :ok, location: @zone_assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @zone_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zone_assignments/1 or /zone_assignments/1.json
  def destroy
    @zone_assignment.destroy!

    respond_to do |format|
      format.html { redirect_to zone_assignments_path, status: :see_other, notice: "Zone assignment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zone_assignment
      @zone_assignment = ZoneAssignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def zone_assignment_params
      params.require(:zone_assignment).permit(:user_id, :assigned_by_id, :zone)
    end
end
