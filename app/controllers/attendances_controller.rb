class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show edit update destroy ]
  before_action :is_administrator?, except: [:new, :create]
  before_action :authenticate_user!
  before_action :already_participate?, only: [:new, :create]
  
  # GET /attendances or /attendances.json
  def index
    @attendances = Attendance.where(event_id: params[:event_id])
    @event = Event.find(params[:event_id])
  end
  
  # GET /attendances/1 or /attendances/1.json
  def show
  end
  
  # GET /attendances/new
  def new
    @event = Event.find(params[:event_id])
    @attendance = Attendance.new
  end
  
  # GET /attendances/1/edit
  def edit
  end
  
  # POST /attendances or /attendances.json
  def create
    @attendance = Attendance.new()
    @attendance.user = current_user
    @attendance.event = Event.find(params[:event_id])
    
    respond_to do |format|
      if @attendance.save
        flash[:success] = "Attendance was successfully created."
        format.html { redirect_to event_url(params[:event_id]) }
        format.json { render :show, status: :created, location: @attendance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /attendances/1 or /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        flash[:success] = "Attendance was successfully updated."
        format.html { redirect_to attendance_url(@attendance.event.id, @attendance) }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /attendances/1 or /attendances/1.json
  def destroy
    @attendance.destroy
    flash[:success] = "Attendance was successfully destroyed."
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end
  
  # Only allow a list of trusted parameters through.
  def attendance_params
    params.require(:attendance).permit(:stripe_customer_id)
  end
  
  def is_administrator?
    @event = Event.find(params[:event_id])
    if @event.administrator != current_user
      flash[:warning] = "Tu n'est pas l'organisateur"
      redirect_to event_path(@event)
    end
  end
  
end
