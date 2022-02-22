ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :role, :password, :password_confirmation

  includes(:company)

  index do
    selectable_column
    column :email
    column "Company name" do |user|
      user.company.name
    end
    column :role
    column :sign_in_count
    column :social_account_integrated
    column :total_posts
    actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :role
      row :sign_in_count
      row :social_account_integrated
      row :total_posts
    end
  end

  filter :email
  filter :role

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :role
      f.input :company, prompt: "Select company"
    end
    f.actions
  end

end
