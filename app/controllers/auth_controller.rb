class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:signup, :signin, :reset_password]
  
  def signup
    user = User.new(user_params)
    
    if user.save
      token = AuthService.generate_token(user)
      render json: {
        user: user_json(user),
        token: token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def signin
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = AuthService.generate_token(user)
      render json: {
        user: user_json(user),
        token: token
      }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
  
  def signout
    # JWT tokens are stateless, so we just return success
    render json: { message: 'Signed out successfully' }
  end
  
  def reset_password
    user = User.find_by(email: params[:email])
    
    if user
      # In a real app, you would send a password reset email
      render json: { message: 'Password reset instructions sent to your email' }
    else
      render json: { error: 'Email not found' }, status: :not_found
    end
  end
  
  def change_email
    if current_user.update(email: params[:email])
      render json: { message: 'Email updated successfully' }
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def change_password
    if current_user.authenticate(params[:current_password])
      if current_user.update(password: params[:new_password])
        render json: { message: 'Password updated successfully' }
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Current password is incorrect' }, status: :unauthorized
    end
  end
  
  def delete_account
    if current_user.authenticate(params[:password])
      current_user.destroy
      render json: { message: 'Account deleted successfully' }
    else
      render json: { error: 'Password is incorrect' }, status: :unauthorized
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :bio, :website, :location)
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
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
