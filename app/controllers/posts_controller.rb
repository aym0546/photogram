class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def index
    @posts = Post.all
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
