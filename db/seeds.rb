# Demo users
user1 = User.find_or_create_by!(email: "ivan@example.com") do |u|
  u.name     = "Іван Петренко"
  u.password = "password123"
end

user2 = User.find_or_create_by!(email: "olena@example.com") do |u|
  u.name     = "Олена Коваль"
  u.password = "password123"
end

# Demo bookings this week
today = Date.current
monday = today.beginning_of_week(:monday)

Booking.find_or_create_by!(user: user1, date: monday, start_time: "12:00", end_time: "15:00") do |b|
  b.notes = "Сімейний пікнік, 4 особи"
end

Booking.find_or_create_by!(user: user2, date: monday + 2, start_time: "16:00", end_time: "19:00") do |b|
  b.notes = "День народження!"
end

Booking.find_or_create_by!(user: user1, date: monday + 4, start_time: "11:00", end_time: "13:00")

puts "Seeds done! Users: ivan@example.com / olena@example.com (password: password123)"
