class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
    
    after_create :welcome_send
    
    validates :email, presence: true
    
    has_many :attendances
    has_many :events, through: :attendances
    has_many :admins, class_name: "Event", foreign_key: "administrator_id"
    
    
    def welcome_send
        UserMailer.welcome_email(self).deliver_now
    end
    
end