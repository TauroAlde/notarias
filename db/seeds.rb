# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', username: "admin")
group = Group.create!(name: "Administrators")
UserGroup.create!(user: admin, group: group)
common_user = User.create!(email: 'common@example.com', password: 'password', password_confirmation: 'password', username: "common")
common_group = Group.create!(name: "Common")
UserGroup.create!(user: common_user, group: common_group)