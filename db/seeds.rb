# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = User.create!([
  { name: "Adit Gustiana", email: "adit@gustianar.com", phone: "081234567890" },
  { name: "Rina Wulandari", email: "rina@example.com", phone: "082233445566" },
  { name: "Budi Santoso", email: "budi@example.com", phone: "083344556677" }
])

users.each do |user|
  3.times do |i|
    Job.create!(
      title: "Software Developer",
      description: "#{user.name} is a software developer",
      status: ["pending", "in_progress", "completed"].sample,
      user_id: user.id
    )
  end
end

puts "Seeding finished"