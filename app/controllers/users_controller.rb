class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update]

  def show
  end

  def update
    if @user.update(user_params)
      # 成功した時、アバター画像の url を返す
      avatar_url = @user.avatar.attached? ? url_for(@user.avatar) : nil
      render json: { status: 'ok', user: @user, avatar_url: avatar_url }
    else
      # 不成功の場合のステータスは 422
      render json: { status: 'error', errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
