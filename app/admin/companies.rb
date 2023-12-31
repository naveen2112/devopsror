ActiveAdmin.register Company do

  permit_params :name, :url, :user_limit, :plan_type, :subscription_status,
                users_attributes: [:id, :first_name, :last_name, :role, :email, :password, :password_confirmation]

  filter :name
  filter :url
  filter :user_limit

  index do
    selectable_column
    column :name
    column "Url" do |object|
      "<a href=#{object.url} target='_blank'>#{object.url}</a>".html_safe
    end
    column "Plan Type" do |object|
      object.sales_led? ? "S" : "P"
    end
    column  "User Limit" do |object|
      object.sales_led? ? object.user_limit : "-"
    end
    column :total_users
    column :total_login_count
    column :total_posts
    column :total_no_users_connected_to_linkedin
    column :total_users_invited
    column :total_users_accepted
    column :actions do |company|
      links = []
      links << link_to('View', admin_company_path(company))
      links << link_to('Edit', edit_admin_company_path(company)) if company.sales_led?
      links << link_to('Delete', admin_company_path(company), method: :delete, data: { confirm: 'Are you sure?' })
      links.join(' ').html_safe
    end
  end

  show do
    attributes_table do
      row :name
      row "Url" do |object|
        "<a href=#{object.url} target='_blank'>#{object.url}</a>".html_safe
      end
      row "Organisation Type" do |object|
        object.sales_led? ? "S" : "P"
      end
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
    form.semantic_errors *form.object.errors.keys
    form.inputs do
      form.input :name
      form.input :url
      if form.object.new_record?
        form.input :user_limit
      else
        form.input :user_limit if form.object.sales_led?
        form.input :subscription_status
      end
      form.input :plan_type, input_html: { value: 'Sales led', disabled: true }
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