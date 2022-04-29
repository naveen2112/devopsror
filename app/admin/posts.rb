ActiveAdmin.register Post do

  permit_params :title, :main_url, :preview_image_url, :company_id, :notification, :created_by, :status,
                :image, platform_name: [], commentries_attributes: [:id, :description], tag_ids: []

  includes(:user, :company)

  filter :company
  filter :user
  filter :title
  filter :status, as: :select, collection: {'live' => 0, 'draft' => 1}

  index do
    selectable_column
    column :company
    column :title
    column "Platform Name" do |object|
      object.platform_name&.first&.titleize
    end
    column "Main url" do |object|
      "<a href=#{object.main_url} target='_blank'>#{object.main_url}</a>".html_safe
    end
    column :status
    column :user
    actions
  end

  show do
    attributes_table do
      row :company
      row :title
      row "Main url" do |object|
        "<a href=#{object.main_url} target='_blank'>#{object.main_url}</a>".html_safe
      end
      row "Platform Name" do |object|
        object.platform_name&.first&.titleize
      end
      row :status
      row :user
      row :created_at
      row :updated_at
      row :tags
      row "Image" do |object|
        image_tag object.image, style: 'height: 150px; width: auto;' if object.image.present?
        image_tag object.preview_image_url, style: 'height: 150px; width: auto;' if object.preview_image_url.present?
      end
    end

    panel 'Commentries' do
      table_for post.commentries do
        column :description
      end
    end
  end


  form do |form|
    form.semantic_errors *form.object.errors.keys
    form.object.status = 'draft' #set default draft for create post
    form.inputs do
      if form.object.new_record?
        form.input :company
      end
      form.input :title
      form.input :main_url, input_html: { maxlength: 240 }, hint: "*Maximum 240 characters allowed"
      if form.object.new_record?
        form.input :status, input_html: { disabled: true }
      else
        form.input :status
        form.input :tags, collection: form.object.company.tags, as: :check_boxes
      end
      form.input :platform_name, input_html: { value: "linked_in", name: "post[platform_name][]", disabled: true, cols: "5", rows: "1" }
      form.input :image, :as => :file, hint: "*Maximum size 5MB"
    end
    span class: "commentries" do
      form.has_many :commentries, class: 'has_one' do |f|
        f.input :description, input_html: { maxlength: 3000 }, hint: "*Maximum 3000 characters allowed"
      end
    end
    form.actions
  end

end