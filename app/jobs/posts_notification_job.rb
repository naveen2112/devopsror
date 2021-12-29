class PostsNotificationJob < ApplicationJob
  queue_as :default

  def perform(id)
    post = Post.find(id)
    sleep(5.seconds)
    post.company.users.each do |user|
      PostMailer.send_email(post.id, user.id).deliver_later
    end
  end
end
