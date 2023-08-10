class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
    
    before_create :assign_avatar
    before_update :acceptable_image


    after_create :welcome_send
    
    validates :email, presence: true
    
    has_many :attendances, dependent: :destroy
    has_many :events, through: :attendances
    has_many :admins, class_name: "Event", foreign_key: "administrator_id", dependent: :destroy
    
    has_one_attached :avatar
    
    private
    
    def acceptable_image
        if avatar.attached? == false
            return errors.add(:picture, "You need to add a picture")
        end
        
        if avatar.blob.byte_size >= 2.megabyte
            errors.add(:avatar, "is too big")
        end
        
        acceptable_types = ["image/jpeg", "image/jpeg", "image/png", "image/webp"]
        if acceptable_types.exclude?(avatar.content_type)
            errors.add(:avatar, "must be a JPEG / JPG / WEBP or PNG")
        end
    end
    
    def assign_avatar
        self.avatar.attach(io: File.open(Rails.root.join("app","assets","images","default.jpg")), filename:"default.jpg", content_type:"image/jpg")
    end
    
    def welcome_send
        UserMailer.welcome_email(self).deliver_now
    end
    
end