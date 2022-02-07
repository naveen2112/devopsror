class PostMailer < ApplicationMailer
  def send_email(post_id, user_id)
    @post = Post.find(post_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: "New content is ready to share via SoVocal!"
  end
end
