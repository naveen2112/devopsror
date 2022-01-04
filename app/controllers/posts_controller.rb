class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy, :send_email_notification]
  before_action :set_tags, only: [:new, :create, :edit, :update]

  # GET /posts
  def index
    if params[:search].present? || params[:tag_ids].present?
      @posts = current_company.posts.joins(:commentries, :tags, :company).where("title ILIKE ? OR
                                                     commentries.description ILIKE ?", params[:search], params[:search])
      @posts.where(tag_ids: params[:tag_ids]) if params[:tag_ids].present?
    else
      @posts = current_company.posts.includes(:commentries, :tags, :company).all
    end
  end

  # GET /posts/new
  def new
    @post = current_company.posts.new
  end

  # POST /posts
  def create
    @post = current_company.posts.new(posts_params)
    @post.created_by = current_user
    @post.status = "draft" if params[:commit] == "Save As Draft"

    if @post.save
      respond_to do |format|
        format.js
      end
    else
      render :new
    end
  end

  # GET /posts/:id/edit
  def edit; end

  # PUT /posts/:id
  def update
    if @post.update(posts_params)
      redirect_to posts_path, notice: "Post updated Successfully."
    else
      render :edit
    end
  end

  # DELETE /posts/:id
  def destroy
    if @post.destroy
      redirect_to posts_path, notice: "Post destroyed Successfully."
    else
      redirect_to posts_path, alert: "Something went wrong, please try later."
    end
  end

  # GET /posts/validate_title
  def validate_title
    return render plain: false unless params[:post][:title].present?

    post = current_company.posts.where("LOWER(title) = ?", params[:post][:title].downcase)
    render plain: post.empty? ? 'true' : 'false'
  end

  # GET /posts/:id/send_email_notification
  def send_email_notification
    @post.send_email
  end

  private

  def set_post
    @post = current_company.posts.find(params[:id])
  end

  def set_tags
    @tags = current_company.tags.all
  end

  def posts_params
    params.require(:post).permit(:title, :main_url, :notification, :image, platform_name: [], commentries_attributes:
      [:description], tag_ids: [])
  end
end
