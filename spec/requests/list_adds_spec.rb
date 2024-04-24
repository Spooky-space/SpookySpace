require 'rails_helper'

RSpec.describe "list_adds", type: :request do
  let(:user) { User.create(
      email: 'test@example.com',
      username: 'username',
      password: 'password',
      password_confirmation: 'password'
    )
  }

  describe "GET /index" do
    it "gets a list of movie lists" do
      list_add = user.list_adds.create(
        watched: false,
        rating: 0,
        tmdb_api_id: 1234
      )
      get list_adds_path
      expect(response).to have_http_status(200)
      expect(list_add).to be_valid
    end
  end

  describe 'POST #create' do
    it 'creates a valid movie list with http success' do
      post list_adds_path, params: {
        list_add: {
          tmdb_api_id: 1234,
          watched: false,
          rating: 0,
          user_id: user.id
        }
      }
      list_add = ListAdd.where(tmdb_api_id: 1234).first
      expect(response).to have_http_status(200)
      expect(list_add).to be_valid
    end
    it 'creates an invalid list_add' do
      post list_adds_path, params: {
        list_add: {
          tmdb_api_id: nil,
          watched: nil,
          rating: nil,
          user_id: nil
        }
      }
      list_add = ListAdd.where(tmdb_api_id: nil).first
      expect(response).to have_http_status(422)
      expect(list_add).to eq(nil)
    end
  end

  describe 'PATCH #update' do
    it 'updates a valid movie list with http success' do
      post list_adds_path, params: {
        list_add: {
          tmdb_api_id: 234,
          rating: 2,
          watched: true,
          user_id: user.id
        }
      }

      list_add = ListAdd.where(tmdb_api_id: 234).first
      patch list_add_path(list_add), params: {
        list_add: {
          rating: 4,
          watched: false,
          user_id: user.id
        }
      }
      list_add = ListAdd.where(rating: 4).first
      expect(list_add.rating).to eq(4)
      expect(list_add.watched).to eq(false)
      expect(response).to have_http_status(200)
    end
    it 'makes invalid updates to an existing list_add' do
      post list_adds_path, params: {
        list_add: {
          tmdb_api_id: 1234,
          rating: 0,
          watched: false,
          user_id: user.id
        }
      }

      list_add = ListAdd.where(tmdb_api_id: 1234).first
        patch list_add_path(list_add), params: {
        list_add: {
          rating: nil,
          watched: nil,
          user_id: nil
        }
      }
      list_add = ListAdd.where(rating: nil).first
      expect(response).to have_http_status(422)
      expect(list_add).to eq(nil)
    end
  end
end
