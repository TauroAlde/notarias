ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :username, :role_ids, user_roles_attributes: [:user_id, :role_id]

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :roles do |user|
      user.roles.map(&:name)
    end
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :roles

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :password
      f.input :password_confirmation
      f.has_many :user_roles, heading: "Roles" do |ur|
        ur.input :role_id, collection: Role.all, as: :select
      end
    end
    f.actions
  end
end
