require "rubygems"
require "json"

### Publishers
  # Publisher URL: https://rawg.io/api/publishers?page=1&key=c542e67aec3a4340908f9de9e86038af
  # Search through the publisher URL and get a list of publishers Get the first 50 pages of publishers
  # Then looping through the 50 publishers, Search the game API for all the games by that publisher.
      # https://rawg.io/api/games?page=1&publishers=muse-games&key=c542e67aec3a4340908f9de9e86038af
      # For the games, keep looping through to the next page until all "next" variables for the responses are null




### Games
response = Faraday.get "https://rawg.io/api/games?page=1&key=c542e67aec3a4340908f9de9e86038af"

if(response != nil)
  body = response.body
  items = JSON.parse(body)

  games = items['results']
  puts('creating games')

  games.each do |game|
    puts('name: ' + game['name'])
    puts('id: ' + game['id'].to_s)
    puts('img_url: ' + game['background_image'])
    puts('game rating out of 5: ' + game['rating'].to_s)
    puts('metacritic rating: ' + game['metacritic'].to_s)

    # platforms
    puts('Creating platforms: ')
    platforms = game['platforms']
    platforms.each do |platform|
      puts("    " + platform['platform']['name'])
    end

    # genres
    puts('creating genres: ')
    genres = game['genres']
    genres.each do |genre|
      puts("    " + genre['name'])
    end

    # esrb rating
    puts('esrb_rating: ' + game['esrb_rating']['name'].to_s)
    puts('released: ' + game['released'].to_s)
    puts('-------------------------------')
  end

end

