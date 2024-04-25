require 'rails_helper'

RSpec.describe Forum, type: :model do
  # Assuming you have factories set up for User and possibly for Flix; otherwise, create them directly as shown:
  let(:user) { User.create(email: 'user@example.com', username: 'username', password: 'password', password_confirmation: 'password') }

  it 'is valid with valid attributes' do
    comment = Forum.new(
      comment: 'Great movie!',
      tmdb_api_id: 123,
      username: 'movie_fan',
      user_id: user.id
    )
    expect(comment).to be_valid
  end

  it 'is not valid without a comment' do
    comment = Forum.new(
      tmdb_api_id: 123,
      username: 'movie_fan',
      user_id: user.id
    )
    expect(comment).not_to be_valid
    expect(comment.errors[:comment].first).to eq("can't be blank")
  end

  it 'is not valid without a tmdb_api_id' do
    comment = Forum.new(
      comment: 'Great movie!',
      username: 'movie_fan',
      user_id: user.id
    )
    expect(comment).not_to be_valid
    expect(comment.errors[:tmdb_api_id].first).to eq("can't be blank")
  end

  it 'is not valid without a username' do
    comment = Forum.new(
      comment: 'Great movie!',
      tmdb_api_id: 123,
      user_id: user.id
    )
    expect(comment).not_to be_valid
    expect(comment.errors[:username].first).to eq("can't be blank")
  end

  it 'is not valid without a user_id' do
    comment = Forum.new(
      comment: 'Great movie!',
      tmdb_api_id: 123,
      username: 'movie_fan'
    )
    expect(comment).not_to be_valid
    expect(comment.errors[:user_id].first).to eq("can't be blank")
  end

  it 'validates that the comment is longer than 10 characters' do
    comment = Forum.new(
      comment: 'Great!',
      tmdb_api_id: 123,
      username: 'movie_fan',
      user_id: user.id
    )
    expect(comment).not_to be_valid
    expect(comment.errors[:comment].first).to eq('is too short (minimum is 10 characters)')
  end
end
