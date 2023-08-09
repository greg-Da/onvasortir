class ApplicationController < ActionController::Base
    
    before_action :configure_devise_parameters, if: :devise_controller?
    
    def configure_devise_parameters
        devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:first_name, :last_name, :description, :email, :password, :password_confirmation)}
        devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:first_name, :last_name, :description, :email, :password, :password_confirmationm, :current_password)}
    end
    
    
    def already_participate?
        @event = Event.find(params[:event_id])
        if current_user.events.where(id: params[:event_id]) != []
            flash[:warning] =  "Tu ne peux pas t'inscrire plusieurs fois"
            redirect_to event_path(@event)
        end
    end
end
