ActiveAdmin.register Company do

  permit_params :name, :url, :user_limit, :plan_type, :subscription_status,
                users_attributes: [:id, :first_name, :last_name, :role, :email, :password, :password_confirmation]

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
    column :total_users_invited
    column :total_users_accepted
    actions
  end

  show do
    attributes_table do
      row :name
      row :url
      if company.sales_led?
        row :user_limit
      else
        row "No of users" do
          company.users.count
        end
      end
      row :total_login_count
      row :total_posts
      row :total_users_connected_one_social_account
      row :total_users_invited
      row :total_users_accepted
    end
  end

  form do |form|
    form.inputs do
      form.input :name
      form.input :url
      if form.object.new_record?
        form.input :user_limit
      else
        form.input :user_limit if form.object.sales_led?
      end
      form.input :plan_type
      form.input :subscription_status
    end
    span class: "has-one" do
      form.has_many :users, class: 'has_one' do |f|
        f.input :first_name, required: true
        f.input :last_name
        f.input :email, required: true
        f.input :role
        if f.object.new_record?
          f.input :password, required: true
          f.input :password_confirmation, required: true
        end
      end
    end
    form.actions
  end

end