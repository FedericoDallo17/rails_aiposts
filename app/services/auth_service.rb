class AuthService
  SECRET_KEY = Rails.application.credentials.secret_key_base || 'your-secret-key'
  
  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end
  
  def self.decode(token)
    JWT.decode(token, SECRET_KEY)[0]
  rescue JWT::DecodeError
    nil
  end
  
  def self.generate_token(user)
    payload = {
      user_id: user.id,
      exp: 24.hours.from_now.to_i
    }
    encode(payload)
  end
  
  def self.authenticate_user(token)
    return nil unless token
    
    decoded = decode(token)
    return nil unless decoded
    
    User.find(decoded['user_id'])
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
