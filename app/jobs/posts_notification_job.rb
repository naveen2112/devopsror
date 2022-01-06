class PostsNotificationJob < ApplicationJob
  queue_as :default

  def perform(id)
    post = Post.find(id)
    post.company.users.subscribers.each do |user|
      PostMailer.send_email(post.id, user.id).deliver_later
    end
  end
end
