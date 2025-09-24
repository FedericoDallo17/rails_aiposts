class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follow, :unfollow, :followers, :following]
  
  def index
    users = User.includes(:profile_picture_attachment)
                .page(params[:page])
                .per(20)
    
    render json: {
      users: users.map { |user| user_json(user) },
      pagination: pagination_info(users)
    }
  end
  
  def show
    render json: user_json(@user)
  end
  
  def search
    users = User.includes(:profile_picture_attachment)
    
    if params[:name].present?
      users = users.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{params[:name]}%", "%#{params[:name]}%")
    end
    
    if params[:username].present?
      users = users.where("username ILIKE ?", "%#{params[:username]}%")
    end
    
    if params[:email].present?
      users = users.where("email ILIKE ?", "%#{params[:email]}%")
    end
    
    if params[:location].present?
      users = users.where("location ILIKE ?", "%#{params[:location]}%")
    end
    
    users = users.page(params[:page]).per(20)
    
    render json: {
      users: users.map { |user| user_json(user) },
      pagination: pagination_info(users)
    }
  end
  
  def follow
    follow = current_user.active_follows.build(following: @user)
    
    if follow.save
      render json: { message: "Now following #{@user.username}" }
    else
      render json: { errors: follow.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def unfollow
    follow = current_user.active_follows.find_by(following: @user)
    
    if follow&.destroy
      render json: { message: "Unfollowed #{@user.username}" }
    else
      render json: { error: 'Follow relationship not found' }, status: :not_found
    end
  end
  
  def followers
    followers = @user.followers.includes(:profile_picture_attachment)
                    .page(params[:page])
                    .per(20)
    
    render json: {
      followers: followers.map { |follower| user_json(follower) },
      pagination: pagination_info(followers)
    }
  end
  
  def following
    following = @user.following.includes(:profile_picture_attachment)
                    .page(params[:page])
                    .per(20)
    
    render json: {
      following: following.map { |user| user_json(user) },
      pagination: pagination_info(following)
    }
  end
  
  def liked_posts
    posts = current_user.liked_posts.includes(:user, :comments, :likes)
                        .recent
                        .page(params[:page])
                        .per(20)
    
    render json: {
      posts: posts.map { |post| post_json(post) },
      pagination: pagination_info(posts)
    }
  end
  
  def commented_posts
    posts = Post.joins(:comments)
                .where(comments: { user: current_user })
                .includes(:user, :comments, :likes)
                .distinct
                .recent
                .page(params[:page])
                .per(20)
    
    render json: {
      posts: posts.map { |post| post_json(post) },
      pagination: pagination_info(posts)
    }
  end
  
  def mentioned_posts
    posts = current_user.mentioned_posts
                        .includes(:user, :comments, :likes)
                        .recent
                        .page(params[:page])
                        .per(20)
    
    render json: {
      posts: posts.map { |post| post_json(post) },
      pagination: pagination_info(posts)
    }
  end
  
  def tagged_posts
    posts = current_user.tagged_posts
                        .includes(:user, :comments, :likes)
                        .recent
                        .page(params[:page])
                        .per(20)
    
    render json: {
      posts: posts.map { |post| post_json(post) },
      pagination: pagination_info(posts)
    }
  end
  
  def update_profile
    if current_user.update(profile_params)
      render json: user_json(current_user)
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update_profile_picture
    if current_user.profile_picture.attach(params[:profile_picture])
      render json: { message: 'Profile picture updated successfully' }
    else
      render json: { error: 'Failed to update profile picture' }, status: :unprocessable_entity
    end
  end
  
  def update_cover_picture
    if current_user.cover_picture.attach(params[:cover_picture])
      render json: { message: 'Cover picture updated successfully' }
    else
      render json: { error: 'Failed to update cover picture' }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :bio, :website, :location)
  end
  
  def user_json(user)
    {
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      username: user.username,
      email: user.email,
      bio: user.bio,
      website: user.website,
      location: user.location,
      profile_picture_url: user.profile_picture.attached? ? url_for(user.profile_picture) : nil,
      cover_picture_url: user.cover_picture.attached? ? url_for(user.cover_picture) : nil,
      followers_count: user.followers.count,
      following_count: user.following.count,
      posts_count: user.posts.count,
      is_following: current_user&.following&.include?(user),
      created_at: user.created_at,
      updated_at: user.updated_at
    }
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
      liked_by_current_user: current_user&.likes&.exists?(post: post),
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
