
User.destroy_all
Event.destroy_all
Ticket.destroy_all


2.times do |index|
  User.create!(name: Faker::Name.name,
                        email: Faker::Internet.email)
end
20.times do |index|
  Event.create!(event: Faker::RockBand.name,
                description: Faker::Lorem.sentence,
                host: Faker::Name.name,
                venue: Faker::Address.city,
                date_time: Faker::Time.forward(100, :evening)
               )
  end

# Kudzi = User.create(name: "Kudzanayi Dzvairo",email: "kdzvairo@gmail.com")

# Concert = Event.create(event: "Led Zepplin", description: "Fun concert", host: "LiveNation", venue: "MetLife Stadium")
