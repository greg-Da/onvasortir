class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :is_administrator?, except: [:index, :show, :new, :create]
  
  # GET /events or /events.json
  def index
    @events = Event.all
  end
  
  # GET /events/1 or /events/1.json
  def show
  end
  
  # GET /events/new
  def new
    @event = Event.new
  end
  
  # GET /events/1/edit
  def edit
  end
  
  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.administrator = current_user
    
    respond_to do |format|
      if @event.save
        flash[:success] = "Event was successfully created."
        
        format.html { redirect_to event_url(@event) }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        flash[:success] = "Event was successfully updated."
        format.html { redirect_to event_url(@event) }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    
    respond_to do |format|
      flash[:success] = "Event was successfully destroyed."
      format.html { redirect_to events_url}
      format.json { head :no_content }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end
  
  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:start_date, :duration, :title, :description, :price, :location)
  end
  
  def is_administrator?
    if @event.administrator != current_user
      flash[:warning] = "You're not the administrator of the event"
      redirect_to event_path(@event)
    end
  end
end
