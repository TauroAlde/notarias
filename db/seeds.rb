# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#admin = User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', username: "admin")
#group = Group.create!(name: "Administrators")
#UserGroup.create!(user: admin, group: group)
#common_user = User.create!(email: 'common@example.com', password: 'password', password_confirmation: 'password', username: "common")
#common_group = Group.create!(name: "Common")
#UserGroup.create!(user: common_user, group: common_group)
#super_admin = User.create!(email: 'super_admin@example.com', password: 'password', password_confirmation: 'password', username: "super_admin")
#super_admin_group = Group.create!(name: "SuperqAdmin")

# TODO: move all the users creation to this file and iterate to create
permissions = YAML.load_file(File.join(Rails.root, "db", "permissions.yml"))
permissions.each do |groups_key, groups_value|
  groups_value.each do |role_key, role_value|
    role_value.each do |users_key, users_array|
      current_user = current_user = User.create(email: users_array[0]["email"], username: users_array[0]["username"])
      if role_key == "common"
        current_user.roles << Role.common
      elsif role_key == "admin"
        current_user.roles << Role.admin
      elsif role_key == "super_admin"
        current_user.roles << Role.super_admin
      end
    end
  end
end

Candidacy.create([{name: 'Diputado'}, {name: 'Diputado 2'}, {name: 'Diputado 3'}])
PoliticalParty.create([
  { name: 'Partido Verde' },
  { name: 'PRI' },
  { name: 'PAN' },
  { name: 'PRD' },
  { name: 'Morena'},
  { name: 'PT' },
  { name: 'Movimiento Ciudadano' }
])