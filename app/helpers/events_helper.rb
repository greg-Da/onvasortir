module EventsHelper
    def already_participate?(event_id = nil)
        @event = Event.find(event_id)
        if current_user.events.where(id: event_id) != []
            return true
        else
            return false
        end
    end

end
