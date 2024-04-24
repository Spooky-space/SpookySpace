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
    listadd = user.list_adds.create(
      tmdb_api_id: 123,
      watched: true,
      rating: 4
    )
    expect(listadd).to be_valid
  end

  it 'is not valid without a tmdb_api_id' do
    listadd = user.list_adds.create(
      watched: true,
      rating: 4
    )
    expect(listadd).not_to be_valid
    expect(listadd.errors[:tmdb_api_id].first).to eq("can't be blank")
  end

  it 'is not valid without a watched' do
    listadd = user.list_adds.create(
      tmdb_api_id: 123,
      rating: 4
    )
    expect(listadd).not_to be_valid
    expect(listadd.errors[:watched].first).to eq("can't be blank")
  end

  it 'is not valid without a rating' do
    listadd = user.list_adds.create(
      tmdb_api_id: 123,
      watched: true,
    )
    expect(listadd).not_to be_valid
    expect(listadd.errors[:rating].first).to eq("can't be blank")
  end

  it 'is not valid with an invalid rating' do
    listadd = user.list_adds.create(
      tmdb_api_id: 123,
      watched: true,
      rating: 6
    )
    expect(listadd).not_to be_valid
    expect(listadd.errors[:rating].first).to eq('is not included in the list')
  end

  it 'is not valid without a watched status' do
    listadd = user.list_adds.create(
      tmdb_api_id: 123,
      rating: 3,
      watched: nil
    )
    expect(listadd).not_to be_valid
    expect(listadd.errors[:watched].first).to eq("can't be blank")
  end
end
