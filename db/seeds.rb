# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

Attendance.destroy_all
Event.destroy_all
User.destroy_all

10.times do 
    User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        description: Faker::Lorem.sentence(word_count: 20),
        email: "#{Faker::Lorem.word}@yopmail.com",
    )

    Event.create(
        start_date: Faker::Date.between(from: '2014-09-23', to: '2014-09-25'),
        duration: rand(1..1000),
        price: rand(1..1000),
        description: Faker::Lorem.sentence(word_count: 20),
        title: Faker::Lorem.word,
        location: Faker::Lorem.word,
        administrator: User.order('RANDOM()').first
    )


    Attendance.create(
        stripe_customer_id: Faker::Lorem.word,
        event: Event.order('RANDOM()').first,
        user: User.order('RANDOM()').first
    )
end