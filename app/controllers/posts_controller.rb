class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  
  def index
    posts = Post.includes(:user, :comments, :likes)
                .recent
                .page(params[:page])
                .per(20)
    
    render json: {
      posts: posts.map { |post| post_json(post) },
      pagination: pagination_info(posts)
    }
  end
  
  def show
    render json: post_json(@post)
  end
  
  def create
    post = current_user.posts.build(post_params)
    
    if post.save
      render json: post_json(post), status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @post.update(post_params)
      render json: post_json(@post)
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @post.destroy
    render json: { message: 'Post deleted successfully' }
  end
  
  def feed
    posts = current_user.feed_posts
                       .includes(:user, :comments, :likes)
                       .page(params[:page])
                       .per(20)
    
    render json: {
      posts: posts.map { |post| post_json(post) },
      pagination: pagination_info(posts)
    }
  end
  
  def search
    posts = Post.includes(:user, :comments, :likes)
    
    posts = posts.search_by_content(params[:content]) if params[:content].present?
    posts = posts.search_by_user(params[:user]) if params[:user].present?
    posts = posts.search_by_tags(params[:tags]) if params[:tags].present?
    
    # Apply sorting
    case params[:sort]
    when 'newest'
      posts = posts.recent
    when 'oldest'
      posts = posts.order(:created_at)
    when 'most_liked'
      posts = posts.most_liked
    when 'most_commented'
      posts = posts.most_commented
    when 'recently_commented'
      posts = posts.recently_commented
    when 'recently_liked'
      posts = posts.recently_liked
    else
      posts = posts.recent
    end
    
    posts = posts.page(params[:page]).per(20)
    
    render json: {
      posts: posts.map { |post| post_json(post) },
      pagination: pagination_info(posts)
    }
  end
  
  private
  
  def set_post
    @post = current_user.posts.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:content, :tags)
  end
  
  def post_json(post)
    {
      id: post.id,
      content: post.content,
      tags: post.tags,
      user: {
        id: post.user.id,
        username: post.user.username,
        full_name: post.user.full_name,
        profile_picture_url: post.user.profile_picture.attached? ? url_for(post.user.profile_picture) : nil
      },
      likes_count: post.likes_count,
      comments_count: post.comments_count,
      liked_by_current_user: current_user.likes.exists?(post: post),
      created_at: post.created_at,
      updated_at: post.updated_at
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
