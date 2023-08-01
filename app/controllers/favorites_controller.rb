class FavoritesController < ApplicationController
  before_action :set_post

  def create
    @favorite = @post.favorites.create(user: current_user)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @favorite = @post.favorites.find_by(user: current_user)
    @favorite.destroy
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
