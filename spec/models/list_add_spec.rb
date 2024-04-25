require 'rails_helper'

RSpec.describe ListAdd, type: :model do
  let(:user) { User.create(
      email: 'test@example.com',
      username: 'username',
      password: 'password',
      password_confirmation: 'password'
    )
  }

  it 'is valid with valid attributes' do
    list_add = user.list_adds.create(
      tmdb_api_id: 123,
      watched: true,
      rating: 4
    )
    expect(list_add).to be_valid
  end

  it 'is valid with valid false watched attribute' do
    list_add = user.list_adds.create(
      tmdb_api_id: 123,
      watched: false,
      rating: 4
    )
    expect(list_add).to be_valid
  end

  it 'is not valid without a tmdb_api_id' do
    list_add = user.list_adds.create(
      watched: true,
      rating: 4
    )
    expect(list_add).not_to be_valid
    expect(list_add.errors[:tmdb_api_id].first).to eq("can't be blank")
  end

  it 'is not valid without a watched' do
    list_add = user.list_adds.create(
      tmdb_api_id: 123,
      rating: 4
    )
    expect(list_add).not_to be_valid
    expect(list_add.errors[:watched].first).to eq("is not included in the list")
  end

  it 'is not valid without a rating' do
    list_add = user.list_adds.create(
      tmdb_api_id: 123,
      watched: true,
    )
    expect(list_add).not_to be_valid
    expect(list_add.errors[:rating].first).to eq("can't be blank")
  end

  it 'is not valid with an invalid rating' do
    list_add = user.list_adds.create(
      tmdb_api_id: 123,
      watched: true,
      rating: 6
    )
    expect(list_add).not_to be_valid
    expect(list_add.errors[:rating].first).to eq('is not included in the list')
  end

  it 'is not valid without a watched status' do
    list_add = user.list_adds.create(
      tmdb_api_id: 123,
      rating: 3,
      watched: nil
    )
    expect(list_add).not_to be_valid
    expect(list_add.errors[:watched].first).to eq("is not included in the list")
  end
end
