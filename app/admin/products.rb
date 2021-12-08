ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :game_id, :general_rating, :metacritic_rating, :esrb_rating,
                        :image_url, :image, :release_date, :publisher_id, :price,
                        product_genres_attributes: [:id, :product_id, :genre_id, :_destroy],
                        product_platforms_attributes: [:id, :product_id, :platform_id, :_destroy]

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute
    # let's add this piece:


    f.inputs do
      f.has_many :product_genres, allow_destroy: true do |n_f|
        n_f.input :genre
      end

      f.has_many :product_platforms, allow_destroy: true do |n_f|
        n_f.input :platform
      end
      f.input :image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image) : "NO IMAGE 📷"
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    default_main_content

    panel "Other" do

      table_for product.genres do
        column "Genre" do |genre|
          genre.name
        end
      end

      table_for product.platforms do
        column "Platform" do |genre|
          genre.name
        end
      end
    end

    div do
      product.image.present? ? image_tag(product.image) : "NO IMAGE 📷"
    end
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :game_id, :general_rating, :metacritic_rating, :esrb_rating, :image, :release_date, :publisher_id, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
