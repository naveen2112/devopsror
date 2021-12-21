class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:commentries, :tags, :company).all
  end

  def new
    @post = current_company.posts.new
  end

  def create
    @post = current_company.posts.new(posts_params)

    if @post.save
      redirect_to posts_path, notice: "Post created Successfully."
    else
      render :new
    end
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
      redirect_to posts_path, notice: "Post destroyed Successfully."
    else
      redirect_to posts_path, alert: "Something went wrong, please try later."
    end
  end

  private

  def set_post
    @post = current_company.posts.find(params[:id])
  end

  def posts_params
    params.require(:post).permit(:title, :main_url, :notification, platform_name: [], )
  end
end
