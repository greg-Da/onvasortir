class Admins::EventsController < Admins::ApplicationController
    before_action :set_event, only: %i[ show edit update destroy ]
    
    def index
        @to_validate = Event.where(validated: nil)
        @validated = Event.where(validated: true)
        @not_validated = Event.where(validated: false)
    end
    
    def show
    end
    
    def edit
    end
    
    def update
        respond_to do |format|
            if @event.update(event_params)
                flash[:success] = "Event was successfully updated."
                format.html { redirect_to admins_event_path(@event) }
                format.json { render :show, status: :ok, location: @event }
            else
                format.html { render :edit, status: :unprocessable_entity }
                format.json { render json: @event.errors, status: :unprocessable_entity }
            end
        end
    end
    
    
    def destroy
        @event.destroy
        
        respond_to do |format|
            format.html { redirect_to admins_events_url, notice: "event was successfully destroyed." }
            format.json { head :no_content }
        end
    end
    
    private
    def set_event
        @event = Event.find(params[:id])
    end
    
    def event_params
        params.require(:event).permit(:start_date, :duration, :title, :description, :price, :location, :picture, :validated)
    end
    
end
