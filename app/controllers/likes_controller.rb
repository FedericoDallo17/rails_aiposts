class LikesController < ApplicationController
  before_action :set_post
  
  def create
    like = current_user.likes.build(post: @post)
    
    if like.save
      render json: { message: 'Post liked successfully' }
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    like = current_user.likes.find_by(post: @post)
    
    if like&.destroy
      render json: { message: 'Like removed successfully' }
    else
      render json: { error: 'Like not found' }, status: :not_found
    end
  end
  
  def index
    likes = @post.likes.includes(:user).page(params[:page]).per(20)
    
    render json: {
      likes: likes.map { |like| like_json(like) },
      pagination: pagination_info(likes)
    }
  end
  
  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end
  
  def like_json(like)
    {
      id: like.id,
      user: {
        id: like.user.id,
        username: like.user.username,
        full_name: like.user.full_name,
        profile_picture_url: like.user.profile_picture.attached? ? url_for(like.user.profile_picture) : nil
      },
      created_at: like.created_at
    }
  end
  
  def pagination_info(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
  end
end
