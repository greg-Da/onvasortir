class Attendance < ApplicationRecord
    after_create :new_attendant_send

    belongs_to :event
    belongs_to :user


    def new_attendant_send
        AttendanceMailer.new_attendant_email(self).deliver_now
    end
end
