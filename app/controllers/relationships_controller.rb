class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:followed_id])
    current_user.follow!(user)
    render json: {
      following: true,
      followers_count: user.followers.count,
      next_url: relationship_path(current_user.relationship_with(user))
    }
  end

  def destroy
    relationship = Relationship.find(params[:id])
    user = relationship.following

    current_user.unfollow!(user)

    render json: {
      following: false,
      followers_count: user.followers.count,
      next_url: relationships_path(followed_id: user.id)
    }
  end

end
