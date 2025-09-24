require 'swagger_helper'

RSpec.describe 'Authentication', type: :request do
  path '/api/v1/auth/signup' do
    post 'Create a new user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              username: { type: :string },
              email: { type: :string },
              password: { type: :string }
            },
            required: ['first_name', 'last_name', 'username', 'email', 'password']
          }
        }
      }
      
      response '201', 'User created successfully' do
        let(:user) do
          {
            user: {
              first_name: 'John',
              last_name: 'Doe',
              username: 'johndoe',
              email: 'john@example.com',
              password: 'password123'
            }
          }
        end
        
        run_test!
      end
      
      response '422', 'Validation errors' do
        let(:user) do
          {
            user: {
              first_name: '',
              last_name: '',
              username: '',
              email: 'invalid-email',
              password: '123'
            }
          }
        end
        
        run_test!
      end
    end
  end
  
  path '/api/v1/auth/signin' do
    post 'Sign in user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ['email', 'password']
      }
      
      response '200', 'User signed in successfully' do
        let(:user) { create(:user) }
        let(:credentials) do
          {
            email: user.email,
            password: 'password123'
          }
        end
        
        run_test!
      end
      
      response '401', 'Invalid credentials' do
        let(:credentials) do
          {
            email: 'wrong@example.com',
            password: 'wrongpassword'
          }
        end
        
        run_test!
      end
    end
  end
end
