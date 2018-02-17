ActiveAdmin.register Preference do
  permit_params :name, :description, :default_values, :encrypted, :field_type 

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :default_values
    column :encrypted
    column :field_type
    actions
  end

  filter :name
  filter :default_values
  filter :field_type

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :default_values
      f.input :encrypted
      f.input :field_type, collection: Preference.field_types.keys
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :default_values
      row :encrypted
      row :field_type
    end
  end
end
