class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:show, :update, :destroy]
  
  def index
    comments = @post.comments.includes(:user).recent.page(params[:page]).per(20)
    
    render json: {
      comments: comments.map { |comment| comment_json(comment) },
      pagination: pagination_info(comments)
    }
  end
  
  def show
    render json: comment_json(@comment)
  end
  
  def create
    comment = @post.comments.build(comment_params.merge(user: current_user))
    
    if comment.save
      render json: comment_json(comment), status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @comment.update(comment_params)
      render json: comment_json(@comment)
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @comment.destroy
    render json: { message: 'Comment deleted successfully' }
  end
  
  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end
  
  def set_comment
    @comment = current_user.comments.find(params[:id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
  
  def comment_json(comment)
    {
      id: comment.id,
      content: comment.content,
      user: {
        id: comment.user.id,
        username: comment.user.username,
        full_name: comment.user.full_name,
        profile_picture_url: comment.user.profile_picture.attached? ? url_for(comment.user.profile_picture) : nil
      },
      created_at: comment.created_at,
      updated_at: comment.updated_at
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
