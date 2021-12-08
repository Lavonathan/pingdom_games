# https://api.rawg.io/docs/#operation/games_list      << DOCUMENTATION ON API

require "rubygems"
require "json"
require "csv"

ProductOrder.delete_all
Order.delete_all
User.delete_all
Province.delete_all
ProductGenre.delete_all
ProductPlatform.delete_all
# Platform.delete_all
Product.delete_all
Publisher.delete_all
# Genre.delete_all

# Testing parameters. Set this when you are testing seeding.
testing = true
province_test = false

### Creating the provinces
csv_file = Rails.root.join("db/provinces.csv")
csv_data = File.read(csv_file)
provinces = CSV.parse(csv_data, headers: true, encoding: "utf-8")

puts "Creating provinces . . . "
provinces.each do |prov|
  puts "#{prov['name']} is being created."

  province = Province.create(
    name: prov["name"],
    HST:  prov["HST"],
    GST:  prov["GST"],
    PST:  prov["PST"],
    code: prov["code"]
  )
  puts "Invalid province #{prov['name']}" unless province&.valid?
end

### Creating Test Users
User.create(email: "TEST1@Testing.com", user_name: "Testonathon1",
            password: 'password', password_confirmation: 'password',
            province: Province.second)

User.create(email: "TEST2@Testing.com", user_name: "Testonathon2",
            password: 'password', password_confirmation: 'password',
            province: Province.second)

User.create(email: "TEST3@Testing.com", user_name: "Testonathon3",
            password: 'password', password_confirmation: 'password',
            province: Province.second)

### Publishers
# Publisher URL: https://rawg.io/api/publishers?page=1&key=c542e67aec3a4340908f9de9e86038af
# Search through the publisher URL and get a list of publishers Get the first 50 pages of publishers
# Then looping through the 50 publishers, Search the game API for all the games by that publisher.
# https://rawg.io/api/games?page=1&publishers=muse-games&key=c542e67aec3a4340908f9de9e86038af
# For the games, keep looping through to the next page until all "next" variables for the responses are null

# Loop through a range of 1 - 10, changing the page number as you go for the publishers
publisher_page_size = 50
publisher_page_num = 1

if testing == true
  publisher_page_size = 1
  publisher_page_num = 2
end

publishers_response = Faraday.get "https://rawg.io/api/publishers?page_size=#{publisher_page_size}&page=#{publisher_page_num}&key=c542e67aec3a4340908f9de9e86038af"

if !publishers_response.nil? && province_test == false
  publishers_body = publishers_response.body
  publishers_items = JSON.parse(publishers_body)

  publishers = publishers_items["results"]

  publishers.each do |publisher|
    publisher_name = publisher["name"]
    publisher_slug = publisher["slug"]
    puts "Creating publisher #{publisher_name}."

    # Find or create publisher with that name.
    publisher = Publisher.find_or_create_by(name: publisher_name)

    # create the games for that publisher
    # continue looping until the games items['next'] is nil
    ### Games (PRODUCTS)
    game_page_size = 50
    more_games = true # flag displaying that publisher has more games.
    page_num = 1

    while more_games == true
      puts("Searching for page No. #{page_num}")
      games_response = Faraday.get "https://rawg.io/api/games?page_size=#{game_page_size}&page=#{page_num}&publishers=#{publisher_slug}&key=c542e67aec3a4340908f9de9e86038af"

      unless games_response.nil?
        body = games_response.body
        items = JSON.parse(body)

        puts("#{publisher_name} has #{items['count']} games")

        games = items["results"]
        puts("creating games for #{publisher_name}.")

        games.each do |game_data|
          game_name = game_data["name"]
          puts "   Creating game: #{game_name}."
          game_id = game_data["id"]
          general_rating = game_data["rating"].to_d
          metacritic_rating = game_data["metacritic"].to_d

          # esrb rating
          begin
            esrb_rating = game_data["esrb_rating"]["name"].to_s
          rescue StandardError
            esrb_rating = nil
          ensure
            puts("esrb_rating: #{esrb_rating} ")
          end

          # game image
          begin
            img_url = game_data["background_image"]
          rescue StandardError
            img_url = nil
          ensure
            puts("img_url: #{img_url}")
          end

          # release date
          begin
            release_date = game_data["released"].to_s
          rescue StandardError
            release_date = nil
          ensure
            puts("released: #{release_date}")
          end

          # Faker for a generated product price.
          price = Faker::Commerce.price(range: 60..98.99, as_string: true).to_d
          puts "#{game_name} is selling for $#{price}."

          # Only create the game if there is an associated release date.
          if release_date.nil? || release_date.strip == ""
            puts "No release date found for #{game_name}. Not including in product catalogue."
          else
            game = Product.find_or_create_by(name: game_name, game_id: game_id, general_rating: general_rating, publisher: publisher, price: price,
                                             metacritic_rating: metacritic_rating, esrb_rating: esrb_rating, image_url: img_url, release_date: release_date)

            ## Add image to product if available.
            unless img_url.nil?
              downloaded_image = URI.open(img_url)
              game.image.attach(io: downloaded_image, filename: "m-#{game_name}_img.jpg")
            end

            # platforms
            puts("Creating platforms: ")
            begin
              platforms = game_data["platforms"]
              platforms.each do |platform|
                platform_name = platform["platform"]["name"]

                unless Platform.exists?(name: platform_name)
                  puts "Creating Platform: #{platform_name}."
                end

                platform = Platform.find_or_create_by(name: platform_name)

                # Create joiner table record for the product platform
                ProductPlatform.find_or_create_by(product: game, platform: platform)
              end
            rescue StandardError
              puts("    " + "NO PLATFORMS")
            end

            # genres
            puts("creating genres: ")
            genres = game_data["genres"]
            genres.each do |genre|
              genre_name = genre["name"]

              puts "Creating Genre: #{genre_name}." unless Genre.exists?(name: genre_name)

              genre = Genre.find_or_create_by(name: genre_name)

              # Create joiner table record for the product genre.
              ProductGenre.find_or_create_by(product: game, genre: genre)
            end
          end # Release date if

          puts("-------------------------------")
        end # games loop
      end # games response

      # check for next page
      begin
        if !items["next"].nil?
          page_num += 1
          sleep(1)

          # Cut the loop early if you are testing.
          more_games = false if testing == true
        else
          more_games = false
          puts("all games created for #{publisher_name}")
        end
      rescue StandardError
        more_games = false
        puts("all games created for #{publisher_name}")
      end

    end # while loop
  end # publishers loop
end # publisher response

### Creating a Test Order
test_product = Product.first
product_price = test_product.price
product_quantity = 20
payment_no_tax = product_price * product_quantity
gst_amount = product_price * User.first.province.GST / 100
hst_amount = product_price * User.first.province.HST / 100
pst_amount = product_price * User.first.province.PST / 100
payment_total = payment_no_tax + gst_amount + hst_amount + pst_amount

test_order = Order.create(order_no: 123, payment_amount_no_tax: payment_no_tax, GST: gst_amount, HST: hst_amount, PST: pst_amount,
                          payment_total: payment_total, pay_date: Date.current, user: User.first)

### Creating test product order
ProductOrder.create(product: test_product, order: test_order, quantity: product_quantity,
                    price: product_price)

puts "#{Province.all.count} Provinces have been created."
puts "#{Publisher.all.count} Publishers have been created."
puts "#{Product.all.count} Products have been created."
puts "#{Platform.all.count} Platforms have been created."
puts "#{Genre.all.count} Genres have been created."
puts "#{User.all.count} Users have been created."
puts "#{Order.all.count} Orders have been created."
puts "#{ProductOrder.all.count} ProductOrders have been created."

# Active admin user creation.
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
puts "#{AdminUser.all.count} Admin #{'user'.pluralize(AdminUser.all.count)}."
