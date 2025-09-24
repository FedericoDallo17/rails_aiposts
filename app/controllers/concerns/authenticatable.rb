module Authenticatable
  extend ActiveSupport::Concern
  
  included do
    before_action :authenticate_user!
  end
  
  private
  
  def authenticate_user!
    @current_user = AuthService.authenticate_user(auth_token)
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
  
  def current_user
    @current_user
  end
  
  def auth_token
    request.headers['Authorization']&.split(' ')&.last
  end
end
