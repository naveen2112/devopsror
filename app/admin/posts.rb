ActiveAdmin.register Post do

  permit_params :title, :main_url, :preview_image_url, :company_id, :notification, :created_by, :status, :platform_name,
                :image, commentries: [:description], tag_ids: []

  filter :company
  filter :user
  filter :title
  filter :platform_name
  filter :status

  index do
    selectable_column
    column :company
    column :title
    column "Platform Name" do |object|
      object.platform_name&.first&.titleize
    end
    column :main_url
    column :status
    column :user
    column :notification
    actions
  end

  show do
    attributes_table do
      row :company
      row :title
      row :main_url
      row "Platform Name" do |object|
        object.platform_name&.first&.titleize
      end
      row :status
      row :notification
      row :user
      row :preview_image_url
      row :created_at
      row :updated_at
      row :tags
      row "Image" do |object|
        image_tag object.image, style: 'height: 150px; width: auto;'
      end
    end

    panel 'Commentries' do
      table_for post.commentries do
        column :description
      end
    end
  end


  form do |form|
    form.inputs do
      form.input :company
      form.input :user
      form.input :title
      form.input :main_url
      form.input :status
      form.input :preview_image_url
      form.input :tags
      form.input :platform_name, as: :select, collection: ["linked_in", "twitter", "facebook"]
      form.input :notification
      form.input :image, :as => :file
    end
    span class: "commentries" do
      form.has_many :commentries, class: 'has_one' do |f|
        f.input :description
      end
    end
    form.actions
  end

end