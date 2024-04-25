require 'rails_helper'

RSpec.describe "Forum", type: :request do
  let(:user) { User.create(
      email: 'test@example.com',
      username: 'username',
      password: 'password',
      password_confirmation: 'password'
    )
  }

    describe "GET /index" do
      it "gets a list of comments" do
        comment = user.forums.create(
          comment: "Test movie comment",
          tmdb_api_id: 1234,
          username: "TestUserName",
        )
        get forums_path
        expect(response).to have_http_status(200)
        expect(comment).to be_valid
      end
    end

    describe 'POST #create' do
    it 'creates a valid comment with http success' do
      post forums_path, params: {
        forum: {
          tmdb_api_id: 1234,
          comment: "Test movie comment",
          username: "TestUserName",
          user_id: user.id
        }
      }
      comment = Forum.where(tmdb_api_id: 1234).first
      expect(response).to have_http_status(200)
      expect(comment).to be_valid
    end
    it 'creates an invalid comment' do
      post forums_path, params: {
        forum: {
          tmdb_api_id: nil,
          comment: nil,
          username: nil,
          user_id: nil
        }
      }
      comment = Forum.where(tmdb_api_id: nil).first
      expect(response).to have_http_status(422)
      expect(comment).to eq(nil)
    end
  end

  describe 'PATCH #update' do
    it 'updates a valid comment with http success' do
      post forums_path, params: {
        forum: {
          tmdb_api_id: 1234,
          comment: "Test movie comment",
          username: "TestUserName",
          user_id: user.id
        }
      }

      comment = Forum.where(tmdb_api_id: 1234).first
      patch forum_path(comment), params: {
        forum: {
          comment: "This is an update for the updating the comment section",
          username: "UpdatedTestUserName",
          user_id: user.id
        }
      }
      comment = Forum.where(username: "UpdatedTestUserName").first
      expect(comment.comment).to eq("This is an update for the updating the comment section")
      expect(comment.username).to eq("UpdatedTestUserName")
      expect(response).to have_http_status(200)
    end
    it 'makes invalid updates to an existing comment' do
      post forums_path, params: {
        forum: {
          tmdb_api_id: 1234,
          comment: "Test movie comment",
          username: "TestUserName",
          user_id: user.id
        }
      }

      comment = Forum.where(tmdb_api_id: 1234).first
      patch forum_path(comment), params: {
        forum: {
          comment: nil,
          username: nil,
          user_id: nil
        }
      }
      comment = Forum.where(username: nil).first
      expect(response).to have_http_status(422)
      expect(comment).to eq(nil)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes an comment' do
      comment = user.forums.create(
        tmdb_api_id: 1234,
        comment: "Test movie comment",
        username: "TestUserName"
      )
      expect {
        delete forum_path(comment)
    }.to change(Forum, :count).by(-1)
    expect(response).to have_http_status(204)
    end
  end

  describe '422 error' do
    it 'creates a invalid comment' do
      post forums_path, params: {
        forum: {
          comment: nil,
          username: nil,
          user_id: nil
        }
      }
      comment = Forum.where(tmdb_api_id: nil).first
      expect(response).to have_http_status(422)
      expect(comment).to eq(nil)
    end
  end
end
