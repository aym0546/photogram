class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.includes(:user)

    respond_to do |format|
      format.html
      format.json {
        render json: @comments.to_json(include: {
          user: {
            only: [:account],
            methods: [:avatar_url]
          }
        })
      }
    end
  end
end
