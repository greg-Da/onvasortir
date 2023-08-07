class AttendanceMailer < ApplicationMailer
    default from: ENV['MAILJET_DEFAULT_FROM']

    def new_attendant_email(attendance)
        @attendant = attendance.user
        @event = attendance.event
        @administrator = attendance.event.administrator

        
        mail(to: @administrator.email, subject: 'Un nouveau participant') 

    end
end
