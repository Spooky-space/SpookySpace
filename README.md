# README Spooky Space API

## Rails API Configuration

### Add RSpec dependencies

```
bundle add rspec-rails
rails generate rspec:install
```

### Create a User model via Devise and add appropriate configurations

#### Add devise dependencies

```
bundle add devise
rails generate devise install
rails generate devise User
rails db:migrate
```

#### Modify devise to add username to Users table

```
$ rails generate migration add_username_to_user
```

#### Replace code in migration with this new block db/migrate/

```
class AddUsernameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
  end
end
```

```
rails db:migrate
```

#### Update the application controller app/controllers/application_controller.rb

```
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # pass params for the sign up form
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password])
    # pass params for the sign in form
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password])
  end
end
```

#### Add code to config/environments/development.rb

```
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

#### Create rack_sessions.rb file in app/controllers/concerns/rack_session.rb add snippet below

```
module RackSession
  extend ActiveSupport::Concern
  class FakeRackSession < Hash
    def enabled?
      false
    end
    def destroy; end
  end
  included do
    before_action :set_fake_session
    private
    def set_fake_session
      request.env['rack.session'] ||= FakeRackSession.new
    end
  end
end
```

#### Create registrations and sessions controllers to handle sign ups and logins

```
rails generate devise:controllers users -c registrations sessions
```

#### Replace code in app/controllers/users/registrations_controller.rb

```
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    build_resource(sign_up_params)
    resource.save
    sign_in(resource_name, resource)
    render json: resource
  end
end
```

#### Replace code in app/controllers/users/sessions_controller.rb

```
class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(resource, _opts = {})
    render json: resource
    end
  def respond_to_on_destroy
    render json: { message: "Logged out." }
  end
end
```

#### Update devise routes: config/routes.rb

```
Rails.application.routes.draw do
  devise_for :users,
  path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  end
```

### Configure CORS✅

#### Update config/initializers/cors.rb

```
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'
    resource '*',
    headers: ["Authorization"],
    expose: ["Authorization"],
    methods: [:get, :post, :put, :patch, :delete, :options, :head],
    max_age: 600
  end
end
```

#### Uncomment this from Gemfile

```
gem "rack-cors"
```

### Add JWT dependencies and configurations✅

#### Install dependencies

```
bundle add devise-jwt
```

#### Create Jwt secret key

```
bundle exec rails secret
```

#### Run this command to open the window to add the new secret key

```
EDITOR="code --wait" bin/rails credentials:edit
```

#### Add the secret key below the secret key base using this code

```
jwt_secret_key: <newly-created secret key>
```

#### Manual save the file in vs code and close the file, check for encrypted and saved in the terminal

#### Add this to config/initializers/devise.rb

```
config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.jwt_special_key
  jwt.dispatch_requests = [
    ['POST', %r{^/login$}],
  ]
  jwt.revocation_requests = [
    ['DELETE', %r{^/logout$}]
  ]
  jwt.expiration_time = 5.minutes.to_i
end
```

### Add JWT revocation✅

#### Run this in the terminal

```
rails generate model jwt_denylist
```

#### Add this code to the migration: db/migrate/

```
def change
  create_table :jwt_denylist do |t|
    t.string :jti, null: false
    t.datetime :exp, null: false
  end
  add_index :jwt_denylist, :jti
end
```

#### Migrate

```
rails db:migrate
```

#### Replace this in the app/models/user.rb

```
devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
```

## Rails ListAdd Model

### Generate Model

#### Generate model in the terminal

```
rails g resource ListAdd tmdb_api_id:integer watched:boolean rating:integer user_id:bigint user:references
```

#### Define the relationship between list_adds and the User in app/models/user.rb

```
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  has_many :list_adds
end
```

#### Define the relationship between ListAdd and the User in app/models/ListAdd.rb

```
class ListAdd < ApplicationRecord
  belongs_to :user
end
```

#### Add a global variable for user to allow for easier testing in spec/models/list_add_spec.rb

```
require 'rails_helper'

RSpec.describe ListAdd, type: :model do
  let(:user) { User.create(
      email: 'test@example.com',
      username: 'username',
      password: 'password',
      password_confirmation: 'password'
    )
  }
```

#### Add first test to test for valid attributes

```
it 'is valid with valid attributes' do
    list_add = user.list_adds.create(
      tmdb_api_id: 123,
      watched: true,
      rating: 4
    )
    expect(list_add).to be_valid
  end
```

#### add test to validate that "watched: false" is valid

```
it 'is valid with valid false watched attribute' do
    list_add = user.list_adds.create(
      tmdb_api_id: 123,
      watched: false,
      rating: 4
    )
    expect(list_add).to be_valid
  end
```

#### Add test for validating presence of attributes repeat for each data column making sure to update the it statement and the expect statement

```
it 'is not valid without a tmdb_api_id' do
    list_add = user.list_adds.create(
      watched: true,
      rating: 4
    )
    expect(list_add).not_to be_valid
    expect(list_add.errors[:tmdb_api_id].first).to eq("can't be blank")
  end

```

#### Add validation to app/models/list_add.rb

```
class ListAdd < ApplicationRecord
  validates :rating, :tmdb_api_id, presence: true
  validates :rating, inclusion: { in: 0..5 }, allow_nil: true
  validates :watched, inclusion: [true, false]
  validates :watched, exclusion: [nil]
  belongs_to :user
end
```

## Rails Forum Model

### Generate Model

#### Generate model in the terminal

```
rails g resource Forum tmdb_api_id:integer  username:string comment:text user_id:bigint user:references
```

#### Define the relationship between Forum and the User in app/models/user.rb

```
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  has_many :list_adds
  has_many :forums
end
```

#### Define the relationship between Forum and the User in app/models/Forum.rb

```
class Forum < ApplicationRecord
  belongs_to :user
end
```

#### Add a global variable for user to allow for easier testing in spec/models/forum_spec.rb

```
require 'rails_helper'

RSpec.describe Forum, type: :model do
  let(:user) { User.create(
      email: 'test@example.com',
      username: 'username',
      password: 'password',
      password_confirmation: 'password'
    )
  }
```

#### Add first test to test for valid attributes

```
it 'is valid with valid attributes' do
    comment = Forum.new(
      comment: 'Great movie!',
      tmdb_api_id: 123,
      username: 'movie_fan',
      user_id: user.id
    )
    expect(comment).to be_valid
  end
```

#### Add test for validating presence of attributes repeat for each data column making sure to update the it statement and the expect statement

```
it 'is not valid without a comment' do
    comment = Forum.new(
      tmdb_api_id: 123,
      username: 'movie_fan',
      user_id: user.id
    )
    expect(comment).not_to be_valid
    expect(comment.errors[:comment].first).to eq("can't be blank")
  end

```

#### Add validation to app/models/forum.rb

```
class Forum < ApplicationRecord
  validates :comment, :tmdb_api_id, :username, :user_id, presence: true
  validates :comment, length: { minimum:10 }
  belongs_to :user
end
```

## API Endpoints

### Testing ListAdd

#### Add a global user variable for the test file

```
RSpec.describe "list_adds", type: :request do
  let(:user) { User.create(
      email: 'test@example.com',
      username: 'username',
      password: 'password',
      password_confirmation: 'password'
    )
  }
```

### Add a mock GET request for index

```
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
```

#### Add a mock POST request for create

```
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
```

#### Add a mock PATCH request for update

```
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
```

#### Add a mock DESTORY request for delete

```
describe 'DELETE #destroy' do
    it 'deletes an comment' do
      list_add = user.list_adds.create(
          tmdb_api_id: 1234,
          rating: 0,
          watched: false,
          user_id: user.id
      )
      expect {
        delete list_add_path(list_add)
    }.to change(ListAdd, :count).by(-1)
    expect(response).to have_http_status(204)
    end
  end
```

#### test for 422 http error on failed list_add

```
 describe '422 error' do
    it 'creates a invalid list_add' do
      post list_adds_path, params: {
        list_add: {
          tmdb_api_id: nil,
          rating: nil,
          watched: nil,
          user_id: nil
        }
      }
      list_add = ListAdd.where(tmdb_api_id: nil).first
      expect(response).to have_http_status(422)
      expect(list_add).to eq(nil)
    end
  end
end
```

### Testing Forum

#### Add a global user variable for the test file

```
RSpec.describe "Forum", type: :request do
  let(:user) { User.create(
      email: 'test@example.com',
      username: 'username',
      password: 'password',
      password_confirmation: 'password'
    )
  }
```

### Add a mock GET request for index

```
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
```

#### Add a mock POST request for create

```
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
```

#### Add a mock PATCH request for update

```
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
```

#### Add a mock DESTORY request for delete

```
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
```

#### test for 422 http error on failed apartment

```
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
```

### Controller methods

#### Add index method to app/controllers/list_adds_controller.rb

```
class ListAddsController < ApplicationController

  def index
    listadds = ListAdd.all
    render json: listadds
  end
```

#### Add create method to app/controllers/apartments_controller.rb

```
def create
    listadd = ListAdd.create(listadd_params)
    if listadd.valid?
      render json: listadd
    else
      render json: listadd.errors, status: 422
    end
  end
```

#### Add update method to app/controllers/apartments_controller.rb

```
def update
    listadd = ListAdd.find(params[:id])
    listadd.update(listadd_params)
    if listadd.valid?
      render json: listadd
    else
      render json: listadd.errors, status: 422
    end
  end
```

#### Add destory method to app/controllers/apartments_controller.rb

```
 def destroy
    listadd = ListAdd.find(params[:id])
    listadd.destroy
  end
```

#### Add params method in private

```
private
  def listadd_params
    params.require(:list_add).permit(:tmdb_api_id, :watched, :rating, :user_id)
  end
end
```

## Add seeds to db/seeds.rb

#### Add seed data to seed file

```
user1 = User.where(email: "test1@example.com").first_or_create(username: "User1", password: "password", password_confirmation: "password")
user2 = User.where(email: "test2@example.com").first_or_create(username:"User2", password: "password", password_confirmation: "password")

  User1ListAdds = [
    {
      tmdb_api_id: 1,
      watched: false,
      rating: 0
    },

    {
        tmdb_api_id: 2,
        watched: false,
        rating: 0
    },

    {
      tmdb_api_id: 3,
      watched: false,
      rating: 0
    },

    {
        tmdb_api_id: 4,
        watched: false,
        rating: 0
    }
  ]
User1ListAdds.each do |list_add|
  user1.list_adds.create(list_add)
  puts "Creating: #{list_add}"
end

User1Forum = [
  {
    tmdb_api_id: 1,
    username: user1.username,
    comment:"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in purus tellus. Vestibulum in lacus nec orci bibendum euismod ac a lorem."
  },

  {
      tmdb_api_id: 2,
      username: user1.username,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in purus tellus. Vestibulum in lacus nec orci bibendum euismod ac a lorem."
  },

  {
    tmdb_api_id: 3,
    username: user1.username,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in purus tellus. Vestibulum in lacus nec orci bibendum euismod ac a lorem."
  },

  {
      tmdb_api_id: 4,
      username: user1.username,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in purus tellus. Vestibulum in lacus nec orci bibendum euismod ac a lorem."
  }
]
User1Forum.each do |comment|
  user1.comments.create(comment)
  puts "Creating: #{comment}"
end

User2ListAdds = [
  {
    tmdb_api_id: 1,
    watched: false,
    rating: 0
  },

  {
      tmdb_api_id: 2,
      watched: false,
      rating: 0
  },
  {
    tmdb_api_id: 3,
    watched: false,
    rating: 0
  },

  {
      tmdb_api_id: 4,
      watched: false,
      rating: 0
  }
]
User2ListAdds.each do |list_add|
  user2.list_adds.create(list_add)
  puts "Creating: #{list_add}"
end

User2Forum = [
  {
    tmdb_api_id: 1,
    username: user2.username,
    comment:"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in purus tellus. Vestibulum in lacus nec orci bibendum euismod ac a lorem."
  },

  {
      tmdb_api_id: 2,
      username: user2.username,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in purus tellus. Vestibulum in lacus nec orci bibendum euismod ac a lorem."
  },

  {
    tmdb_api_id: 3,
    username: user2.username,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in purus tellus. Vestibulum in lacus nec orci bibendum euismod ac a lorem."
  },

  {
      tmdb_api_id: 4,
      username: user2.username,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in purus tellus. Vestibulum in lacus nec orci bibendum euismod ac a lorem."
  }
]
User2Forum.each do |comment|
  user2.comments.create(comment)
  puts "Creating: #{comment}"
end
```

#### commands for db population

```
rails db:reset
<!-- drops database, creates database, and seeds database -->
```
