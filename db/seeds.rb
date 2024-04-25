user1 = User.where(email: "test1@example.com").first_or_create(username: "User1", password: "password", password_confirmation: "password")
user2 = User.where(email: "test2@example.com").first_or_create(username:"User2", password: "password", password_confirmation: "password")

  user_1_list_adds = [
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
  user_1_list_adds.each do |list_add|
  user1.list_adds.create(list_add)
  puts "Creating: #{list_add}"
  end

  user_1_forum = [
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
  user_1_forum.each do |comment|
  user1.comments.create(comment)
  puts "Creating: #{comment}"
  end

  user_2_list_adds = [
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
  user_2_list_adds.each do |list_add|
  user2.list_adds.create(list_add)
  puts "Creating: #{list_add}"
  end

  user_2_forum = [
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
  user_2_forum.each do |comment|
  user2.comments.create(comment)
  puts "Creating: #{comment}"
  end
