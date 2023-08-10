class Event < ApplicationRecord
    validate :not_in_past
    validates :start_date, presence: true
    
    validate :is_positive_and_multiple_of_five
    validates :duration, presence: true
    
    validates :title, presence: true, length: {minimum: 5 ,maximum: 140}
    
    validates :description, presence: true, length: {minimum: 20 ,maximum: 1000}
    
    validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000}
    
    validates :location, presence: true
    
    
    has_many :attendances, dependent: :destroy
    has_many :users, through: :attendances
    belongs_to :administrator, class_name: "User", foreign_key: "administrator_id"
    
    has_one_attached :picture
    validate :acceptable_image
    
    
    def end_date
        self.start_date + self.duration.minutes
    end
    
    def is_free?
        self.price == 0 ? true : false
    end
    
    private
    
    def acceptable_image
        if picture.attached? == false
            return errors.add(:picture, "You need to add a picture")
        end
        
        if picture.blob.byte_size >= 2.megabyte
            errors.add(:picture, "is too big")
        end
        
        acceptable_types = ["image/jpeg", "image/jpeg", "image/png", "image/webp"]
        if acceptable_types.exclude?(picture.content_type)
            errors.add(:picture, "must be a JPEG / JPG / WEBP or PNG")
        end
    end
    
    def not_in_past
        if self.start_date < Time.now
            errors.add(:start_date, 'not in past')
        end
    end
    
    def is_positive_and_multiple_of_five
        if self.duration < 1
            errors.add(:duration, 'Must be positve')
        elsif self.duration % 5 != 0
            errors.add(:duration, 'Must be multiple of 5')
        end
    end
end