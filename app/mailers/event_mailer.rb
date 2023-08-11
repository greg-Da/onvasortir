class EventMailer < ActionMailer::Base

    default from: ENV['MAILJET_DEFAULT_FROM']

    def validated_email(event)
       @event = event
       @administrator = event.administrator
       
        mail(to: @administrator.email, subject: 'Evénement validé') 
    end

    def not_validated_email(event)
        @event = event
        @administrator = event.administrator
 
         mail(to: @administrator.email, subject: 'Evénement non validé') 
     end
end