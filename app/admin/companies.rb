ActiveAdmin.register Company do

  permit_params :name, :url, users_attributes: [:id, :first_name, :last_name, :role, :email, :password, :password_confirmation]

  filter :name
  filter :url
  filter :user_limit

  index do
    selectable_column
    column :name
    column :url
    column :user_limit
    column :total_login_count
    column :total_posts
    column :total_users_connected_one_social_account
    actions
  end

  show do
    attributes_table do
      row :name
      row :url
      row :user_limit
      row :total_login_count
      row :total_posts
      row :total_users_connected_one_social_account
    end
  end

  form do |form|
    form.inputs do
      form.input :name
      form.input :url
    end
    span class: "has-one" do
      form.has_many :users, class: 'has_one' do |f|
        f.input :first_name, required: true
        f.input :last_name
        f.input :email, required: true
        f.input :role
        if object.new_record?
          f.input :password, required: true
          f.input :password_confirmation, required: true
        end
      end
    end
    form.actions
  end


end