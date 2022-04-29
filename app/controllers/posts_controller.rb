include LinkedinAuthentication

class PostsController < ApplicationController
  load_and_authorize_resource param_method: :posts_params, except: [:share]
  before_action :set_post, only: [:edit, :update, :destroy, :send_email_notification, :show, :share, :validate_tag,
                                  :destroy_image]
  before_action :set_tags, only: [:new, :create, :edit, :update]

  def index
    @posts = if current_user.admin? || current_user.editor?
               current_company.posts
             else
               current_company.posts.where.not(status: "draft")
             end
    @posts = @posts.order("posts.updated_at DESC").with_includes

    if params[:search].present? || params[:tag_ids].present?
      @posts = @posts.joins(:tags).where(tags: { id: params[:tag_ids] }).distinct unless params[:tag_ids].reject(&:blank?).empty? if params[:tag_ids].present?

      if params[:search].present?
        @posts = @posts.joins(:commentries).where("title ILIKE :search OR main_url ILIKE :search OR
                                                     commentries.description ILIKE :search", { search: "%#{params[:search]}%" }).distinct
      end
    else
      @posts = @posts.all
    end
    @posts = @posts.page(params[:page]).per_page(8)
  end

  def share
    response = share_post(@post.id, current_user.id, params[:commentry].strip)
    if response["id"].present?
      @post.increment!(:shared_count)
      redirect_to posts_path, notice: "Your Post Was Shared Successfully."
    else
      redirect_to posts_path, alert: "Something went wrong."
    end
  end

  def new
    @post = current_company.posts.new
  end

  def show
    session["post_id"] = @post.id
  end

  def create
    @post = current_company.posts.new(posts_params)
    @post.user = current_user
    @post.status = "draft" if params[:commit] == "Save As Draft"

    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def validate_tag
    return render plain: false unless params[:tag_ids].present?

    @tags = @post.tags.where(id: params[:tag_ids].split(","))
    render json: @tags
  end

  def edit; end

  def update
    if @post.update(posts_params)
      redirect_to posts_path, notice: "Post updated Successfully."
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      respond_to do |format|
        format.js
      end
    else
      redirect_to posts_path, alert: "Something went wrong, please try later."
    end
  end

  def validate_title
    return render plain: false unless params[:post][:title].present?

    post = current_company.posts.where("LOWER(title) = ?", params[:post][:title].downcase)
    render plain: post.empty? ? 'true' : 'false'
  end

  def validate_title_except_current
    return render plain: false unless params[:post][:title].present?

    post = current_company.posts.where("LOWER(title) = ? AND id != ?", params[:post][:title].downcase, params[:id])
    render plain: post.empty? ? 'true' : 'false'
  end

  def send_email_notification
    @post.send_email
    flash[:notice] = "Email notification for the post sent successfully"
  end

  def destroy_image
    @post.image.destroy
    head :ok
  end

  # Pulling image from given main URL using MetaInspector
  def preview_image_from_url
    begin
      page = MetaInspector.new(posts_params[:main_url], faraday_options: { ssl: { verify: false } },
                               :connection_timeout => 5, :read_timeout => 5)

      if page.meta_tags['property']['og:image'].present?
        preview_image_url = page.meta_tags['property']['og:image'].first if page.meta_tags['property']['og:image'].first != 'http:/'
      end
    rescue MetaInspector::TimeoutError, MetaInspector::RequestError, MetaInspector::ParserError, MetaInspector::NonHtmlError => e
      preview_image_url = nil
    end

    render plain: preview_image_url || 'false'
  end
  private

  def set_post
    @post = current_company.posts.find_by(id: params[:id])
  end

  def set_tags
    @tags = current_company.tags.all
  end

  def posts_params
    param_object = params.require(:post).permit(:title, :main_url, :notification, :image, platform_name: [], commentries_attributes:
      [:id, :description], tag_ids: [], tags_attributes: [:name, :company_id])

    param = if params["commit"] == "Update Post" || params[:commit] == "Create Post"
              param_object.merge(status: "live")
            else
              param_object.merge(status: "draft")
            end
    param
  end
end
