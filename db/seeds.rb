# https://api.rawg.io/docs/#operation/games_list      << DOCUMENTATION ON API

require "rubygems"
require "json"

Publisher.delete_all

### Publishers
  # Publisher URL: https://rawg.io/api/publishers?page=1&key=c542e67aec3a4340908f9de9e86038af
  # Search through the publisher URL and get a list of publishers Get the first 50 pages of publishers
  # Then looping through the 50 publishers, Search the game API for all the games by that publisher.
      # https://rawg.io/api/games?page=1&publishers=muse-games&key=c542e67aec3a4340908f9de9e86038af
      # For the games, keep looping through to the next page until all "next" variables for the responses are null

# Loop through a range of 1 - 10, changing the page number as you go for the publishers
publisher_page_size = 1
publisher_page_num = 2

publishers_response = Faraday.get "https://rawg.io/api/publishers?page_size=#{publisher_page_size}&page=#{publisher_page_num}&key=c542e67aec3a4340908f9de9e86038af"

if(publishers_response != nil)
  publishers_body = publishers_response.body
  publishers_items = JSON.parse(publishers_body)

  publishers = publishers_items['results']

  publishers.each do |publisher|
    publisher_name = publisher['name']
    publisher_slug = publisher['slug']
    puts "Creating publisher #{publisher_name}."

    # Find or create publisher with that name.
    publisher = Publisher.find_or_create_by(name: publisher_name)

    # create the games for that publisher
    # continue looping until the games items['next'] is nil
    ### Games
    game_page_size = 50
    more_games = true
    page_num = 1

    while more_games == true
      puts("Searching for page No. #{page_num}")
      games_response = Faraday.get "https://rawg.io/api/games?page_size=#{game_page_size}&page=#{page_num}&publishers=#{publisher_slug}&key=c542e67aec3a4340908f9de9e86038af"

      if(games_response != nil)
        body = games_response.body
        items = JSON.parse(body)

        puts("Publisher has #{items['count']} games")

        games = items['results']
        puts('creating games')

        games.each do |game|
          puts('name: ' + game['name'])
          puts("publisher: #{publisher_name}" )
          puts('id: ' + game['id'].to_s)
          puts('game rating out of 5: ' + game['rating'].to_s)
          puts('metacritic rating: ' + game['metacritic'].to_s)

          # platforms
          puts('Creating platforms: ')
          begin
            platforms = game['platforms']
            platforms.each do |platform|
              puts("    " + platform['platform']['name'])
            end
          rescue
            puts("    " + "NO PLATFORMS")
          end

          # genres
          puts('creating genres: ')
          genres = game['genres']
          genres.each do |genre|
            puts("    " + genre['name'])
          end

          # esrb rating
          begin
            esrb_rating = game['esrb_rating']['name'].to_s
          rescue
            esrb_rating = "NONE"
          ensure
            puts("esrb_rating: #{esrb_rating} ")
          end

          # game image
          begin
            img_url = game['background_image']
          rescue
            img_url = "NONE"
          ensure
            puts("img_url: #{img_url}")
          end

          # release date
          begin
            release_date = game['released'].to_s
          rescue
            release_date = "UNRELEASED"
          ensure
            puts("released: #{release_date}")
          end

          puts('-------------------------------')
        end # games loop
      end # games response

      # check for next page
      begin
        if items['next'] != nil
          page_num += 1
          sleep(1)
        else
          more_games = false
          puts("all games created for #{publisher_name}")
        end
      rescue
        more_games = false
        puts("all games created for #{publisher_name}")
      end

    end # while loop

  end # publishers loop
end # publisher response

puts "#{Publisher.all.count} Publishers have been created."




