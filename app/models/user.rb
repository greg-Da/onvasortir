class User < ApplicationRecord
    validates :email, presence: true

    has_many :attendances
    has_many :events, through: :attendances
    has_many :admins, class_name: "Event", foreign_key: "administrator_id"
end
