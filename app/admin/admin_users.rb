ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :role, :password, :password_confirmation, :company_id

  includes(:company)

  index do
    selectable_column
    column :email
    column "Company name" do |user|
      user.company.name
    end
    column :role
    column :login_count
    column "Social Account Integrated" do |object|
      object.social_account_integrated > 0 ? "Yes" : "No"
    end
    column :total_posts
    actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :role
      row :login_count
      row "Social Account Integrated" do |object|
        object.social_account_integrated > 0 ? "Yes" : "No"
      end
      row :total_posts
    end
  end

  filter :email
  filter :company

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :role
      f.input :company, prompt: "Select company"
      if f.object.new_record?
        f.input :password, required: true
        f.input :password_confirmation, required: true
      end
    end
    f.actions
  end

end
