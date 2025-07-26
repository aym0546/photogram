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
            only: [:id, :account],
            methods: [:avatar_url]
          }
        })
      }
    end
  end

  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment.as_json(include: { user: { only: [:account], methods: [:avatar_url] } })
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
