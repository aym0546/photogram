class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update]

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'プロフィール画像が更新されました'
    else
      flash.now[:error] = '更新できませんでした'
      render :show
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
