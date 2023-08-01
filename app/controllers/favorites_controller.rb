class FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @post.favorites.create(user: current_user)
  
    respond_to do |format|
      format.turbo_stream
    end
  end
end
