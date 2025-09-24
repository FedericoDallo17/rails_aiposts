class ApplicationController < ActionController::API
  include Authenticatable
  
  # Skip authentication for certain actions
  skip_before_action :authenticate_user!, only: []
end
