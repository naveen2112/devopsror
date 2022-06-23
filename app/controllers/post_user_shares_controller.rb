class PostUserSharesController < ApplicationController

  load_and_authorize_resource
  before_action :set_post_user_shares ,:set_date_ranges, :set_linkedin_social_actions

  def show
    recent_seven_days_share
    shared_details
  end

  def shared_details
    @total_engagements = @post_users_shares.pluck(:likes_count, :comments_count).map(&:sum).sum
    @total_reach = @post_users_shares.map(&:reach_count).sum
    @total_clicks = @linkedin_social_actions.filter_date(@from_date, @end_date).count
    posts_share = @post_users_shares.filter_date(@from_date, @end_date).group(:post_id).order('count_id desc').count('id')
    @posts_title = @current_company.posts.find(posts_share.keys).pluck(:title)
    @posts_shared_count = posts_share.values
    @total_post_shared = @posts_shared_count.sum
    users_share = @post_users_shares.filter_date(@from_date, @end_date).group(:user_id).order('count_id desc').count('id')
    @users = @current_company.users.includes(:logo_attachment).find(users_share.keys)
    @users_shared_count = users_share.values
  end

  def recent_seven_days_share
    @shared_count_per_day = []
    days = 6
    post_user_shares = @post_users_shares.where("DATE(updated_at) >= ?", Date.today - days)
    while days >= 0
      @shared_count_per_day << post_user_shares.select { |share| (share.created_at).to_date == Date.today - days }.count
      days -= 1
    end
  end

  private

  def set_date_ranges
    @from_date = params[:from] || 30.days.ago.to_date
    @end_date = params[:to] || Date.tomorrow
  end

  def set_post_user_shares
    @post_users_shares = @current_company.post_user_shares
  end

  def set_linkedin_social_actions
    @linkedin_social_actions = @current_company.linkedin_social_actions
  end
end
