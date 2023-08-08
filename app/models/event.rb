class Event < ApplicationRecord
    validate :not_in_past
    validates :start_date, presence: true

    validate :is_positive_and_multiple_of_five
    validates :duration, presence: true

    validates :title, presence: true, length: {minimum: 5 ,maximum: 140}

    validates :description, presence: true, length: {minimum: 20 ,maximum: 1000}

    validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000}
    
    validates :location, presence: true

    
    has_many :attendances
    has_many :users, through: :attendances
    belongs_to :administrator, class_name: "User", foreign_key: "administrator_id"
    
    def end_date
        self.start_date + self.duration.minutes
    end

    private
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