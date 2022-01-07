# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy, :send_email_notification, :show]
  before_action :set_tags, only: [:new, :create, :edit, :update]

  # GET /posts
  def index
    @posts = current_company.posts.order("posts.created_at DESC").with_includes

    if params[:search].present? || params[:tag_ids].present?
      if params[:search].present?
        @posts = @posts.joins(:commentries).where("title ILIKE ? OR main_url ILIKE ? OR
                                                     commentries.description ILIKE ?", params[:search], params[:search], params[:search])
      end
      @posts = @posts.where(tags: { id: params[:tag_ids] }) if params[:tag_ids].present?
    else
      @posts = @posts.all
    end
  end

  # GET /posts/new
  def new
    @post = current_company.posts.new
  end

  # GET /posts/:id
  def show; end

  # POST /posts
  def create
    @post = current_company.posts.new(posts_params)
    @post.created_by = current_user
    @post.status = "draft" if params[:commit] == "Save As Draft"

    if @post.save
      redirect_to posts_path
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
