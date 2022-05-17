class PostUserEngagementJob < ApplicationJob
  queue_as :default

  include LinkedinAuthentication

  def perform
    PostUserShare.where("DATE(created_at) >= ?", Date.current - 100.days)&.each do |post_user_share|
      response = get_engagement_details(share_id: post_user_share.share_id, user: post_user_share.user)
      response = JSON.parse(response)
      next if response['status'] == 404

      total_engagement_count = response['commentsSummary']['aggregatedTotalComments'] + response['likesSummary']['aggregatedTotalLikes']
      if total_engagement_count != post_user_share.engagement_count
        post_user_share.update_columns(engagement_count: total_engagement_count)
      end
    end
  end
end
