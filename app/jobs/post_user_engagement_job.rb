class PostUserEngagementJob < ApplicationJob
  queue_as :default

  include LinkedinAuthentication

  def perform
    PostUserShare.where("DATE(created_at) >= ?", Date.current - 100.days)&.each do |post_user_share|
      response = get_engagement_details(share_id: post_user_share.share_id, user: post_user_share.user)
      response = JSON.parse(response)
      next if response['status'] == 404

      likes_count, comments_count = response['commentsSummary']['aggregatedTotalComments'], response['likesSummary']['aggregatedTotalLikes']
      if likes_count != post_user_share.likes_count || comments_count != post_user_share.comments_count
        reach_count = (likes_count * 40) + (comments_count * 100)
        post_user_share.update_columns(likes_count: likes_count, comments_count: comments_count, reach_count: reach_count)
      end
    end
  end
end
