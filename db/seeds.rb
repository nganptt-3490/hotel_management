20.times do |n|
  utility_type = 1
  name = Faker::House.furniture
  quantity = Faker::Number.between(from: 1, to: 5)
  cost = Faker::Number.between(from: 50000, to: 500000)
  Utility.create!(utility_type: utility_type,
                  name: name,
                  quantity: quantity,
                  cost: cost)
end
RoomType.create!(name: "Single Room",
                price_weekday: 500000,
                price_weekend: 600000,
                area: 15,
                number_of_guest_max: 1)
RoomType.create!(name: "Double Room",
                price_weekday: 600000,
                price_weekend: 700000,
                area: 20,
                number_of_guest_max: 3)
RoomType.create!(name: "Triple Room",
                price_weekday: 800000,
                price_weekend: 900000,
                area: 25,
                number_of_guest_max: 4)
RoomType.create!(name: "Quara Room",
                price_weekday: 900000,
                price_weekend: 1000000,
                area: 30,
                number_of_guest_max: 6)
RoomType.create!(name: "Penta Room",
                price_weekday: 1000000,
                price_weekend: 1100000,
                area: 35,
                number_of_guest_max: 8)
RoomType.create!(name: "Hexa Room",
                price_weekday: 1300000,
                price_weekend: 1400000,
                area: 40,
                number_of_guest_max: 10)
RoomType.create!(name: "Single Room",
                price_weekday: 500000,
                price_weekend: 600000,
                area: 15,
                number_of_guest_max: 1)
RoomType.create!(name: "Double Room",
                price_weekday: 600000,
                price_weekend: 700000,
                area: 20,
                number_of_guest_max: 3)
RoomType.create!(name: "Triple Room",
                price_weekday: 800000,
                price_weekend: 900000,
                area: 25,
                number_of_guest_max: 4)
RoomType.create!(name: "Quara Room",
                price_weekday: 900000,
                price_weekend: 1000000,
                area: 30,
                number_of_guest_max: 6)
RoomType.create!(name: "Penta Room",
                price_weekday: 1000000,
                price_weekend: 1100000,
                area: 35,
                number_of_guest_max: 8)
RoomType.create!(name: "Hexa Room",
                price_weekday: 1300000,
                price_weekend: 1400000,
                area: 40,
                number_of_guest_max: 10)
15.times do |n|
  utility_id = n + 1
  quantity= Faker::Number.between(from: 1, to: 2)
  description = Faker::Lorem.sentence(word_count: 5)
  UtilitiesInRoomType.create!(
    room_type_id: 1,
    utility_id: utility_id,
    quantity: quantity,
    description: description
  )
end
10.times do |n|
  utility_id = n + 10
  quantity = Faker::Number.between(from: 1, to: 2)
  description = Faker::Lorem.sentence(word_count: 5)
  UtilitiesInRoomType.create!(
    room_type_id: 2,
    utility_id: utility_id,
    quantity: quantity,
    description: description
  )
end
20.times do |n|
  room_type_id = Faker::Number.between(from: 1, to: 6)
  status = Faker::Number.between(from: 0, to: 1)
  description = Faker::Lorem.sentence(word_count: 5)
  if n < 5
    room_number = 101 + n
  elsif n < 10
    room_number = 201 + n - 5
  elsif n < 15
    room_number = 301 + n - 10
  else room_number = 401 + n - 15
  end
  Room.create!(
              room_type_id: room_type_id,
              room_number: room_number,
              status: status,
              description: description
  )
end

User.create!(username:"Example User",
             email: "example@railstutorial.org",
             password: "abcxyz",
             role: 1
            )

20.times do |n|
  username = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  User.create!(username: username,
               email: email,
               password: "abcxyz",
               role: 0)
end

20.times do |n|
  user_id = Faker::Number.between(from: 1, to: 10)
  room_id = Faker::Number.between(from: 1, to: 5)
  rate = Faker::Number.between(from: 3, to: 5)
  content = Faker::Lorem.sentence(word_count: 5)
  Review.create!(
                user_id: user_id,
                room_id: room_id,
                rate: rate,
                content: content
  )
end

PriceFluctuation.create!(name: "Quốc khánh",
                        start_date: Date.new(2024,9,1),
                        end_date: Date.new(2024,9,4),
                        rate: 1.5)

PriceFluctuation.create!(name: "Tết dương",
                        start_date: Date.new(2024,1,1),
                        end_date: Date.new(2024,1,2),
                        rate: 1.5)

PriceFluctuation.create!(name: "30/4",
                        start_date: Date.new(2024,4,30),
                        end_date: Date.new(2024,5,1),
                        rate: 1.3)

15.times do |n|
  room_id = Faker::Number.between(from: 1, to: 5)
  room_type_id = Faker::Number.between(from: 1, to: 2)
  user_id = Faker::Number.between(from: 1, to: 10)
  start_date = Faker::Date.backward(days: 90)
  end_date = start_date + rand(1..5).days
  Request.create!(room_id: room_id,
                  room_type_id: room_type_id,
                  user_id: user_id,
                  start_date: start_date,
                  end_date: end_date
  )
end

15.times do |n|
  price_fluctuation_id = Faker::Number.between(from: 1, to: 3)
  request_id = n+1
  request = Request.find_by id: request_id
  if request.id = request_id
    room_cost_count = (request.end_date - request.start_date).to_i
    for i in 0..room_cost_count
      use_date = request.start_date + i.days
      RoomCost.create!(request_id: request_id,
                      price_fluctuation_id: price_fluctuation_id,
                      use_date: use_date
      )
    end
  end
end
