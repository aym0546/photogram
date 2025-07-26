class MentionMailer < ApplicationMailer

  def notify_mention(mentioned_user, comment, comment_author)
    @mentioned_user = mentioned_user
    @comment = comment
    @post = comment.post
    @comment_author = comment_author
    mail to: @mentioned_user.email, subject: '【photogram】メンションされました！'
  end

end