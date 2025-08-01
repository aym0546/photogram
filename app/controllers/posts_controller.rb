class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create]

  def index
    followed_posts = Post
      .where(user_id: current_user.following_ids)
      .includes(:user, :likes)

    hot_posts = Post
      .left_joins(:likes)
      .where('posts.created_at >= ?', 24.hours.ago)
      .group('posts.id')
      .order('COUNT(likes.id) DESC')
      .limit(5)
      .includes(:user, :likes)

    @posts = (followed_posts + hot_posts)
      .uniq(&:id)
      .sort_by(&:created_at)
      .reverse
      .take(5)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: 'ポストされました'
    else
      flash.now[:error] = 'ポストされませんでした'
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @post.image.attach(params[:images])：画像追加
  # @post.image.attached?：画像が添付されているか
  def post_params
    params.expect(post: [ :user_id, :caption, images: [] ])
  end
end
