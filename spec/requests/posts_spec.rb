require 'swagger_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { { 'Authorization' => "Bearer #{AuthService.generate_token(user)}" } }
  
  path '/api/v1/posts' do
    get 'Get all posts' do
      tags 'Posts'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      
      response '200', 'Posts retrieved successfully' do
        let(:Authorization) { "Bearer #{AuthService.generate_token(user)}" }
        
        before do
          create_list(:post, 3, user: user)
        end
        
        run_test!
      end
    end
    
    post 'Create a new post' do
      tags 'Posts'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              content: { type: :string },
              tags: { type: :string }
            },
            required: ['content']
          }
        }
      }
      
      response '201', 'Post created successfully' do
        let(:Authorization) { "Bearer #{AuthService.generate_token(user)}" }
        let(:post) do
          {
            post: {
              content: 'This is a new post',
              tags: 'tag1,tag2'
            }
          }
        end
        
        run_test!
      end
      
      response '422', 'Validation errors' do
        let(:Authorization) { "Bearer #{AuthService.generate_token(user)}" }
        let(:post) do
          {
            post: {
              content: '',
              tags: ''
            }
          }
        end
        
        run_test!
      end
    end
  end
  
  path '/api/v1/posts/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Post ID'
    
    get 'Get a specific post' do
      tags 'Posts'
      produces 'application/json'
      security [Bearer: {}]
      
      response '200', 'Post retrieved successfully' do
        let(:Authorization) { "Bearer #{AuthService.generate_token(user)}" }
        let(:id) { create(:post, user: user).id }
        
        run_test!
      end
      
      response '404', 'Post not found' do
        let(:Authorization) { "Bearer #{AuthService.generate_token(user)}" }
        let(:id) { 999 }
        
        run_test!
      end
    end
    
    put 'Update a post' do
      tags 'Posts'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              content: { type: :string },
              tags: { type: :string }
            }
          }
        }
      }
      
      response '200', 'Post updated successfully' do
        let(:Authorization) { "Bearer #{AuthService.generate_token(user)}" }
        let(:id) { create(:post, user: user).id }
        let(:post) do
          {
            post: {
              content: 'Updated post content',
              tags: 'updated,tags'
            }
          }
        end
        
        run_test!
      end
    end
    
    delete 'Delete a post' do
      tags 'Posts'
      security [Bearer: {}]
      
      response '200', 'Post deleted successfully' do
        let(:Authorization) { "Bearer #{AuthService.generate_token(user)}" }
        let(:id) { create(:post, user: user).id }
        
        run_test!
      end
    end
  end
end
