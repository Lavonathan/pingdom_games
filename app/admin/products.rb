ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :game_id, :general_rating, :metacritic_rating, :esrb_rating, :image_url, :image, :release_date, :publisher_id, :price
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :game_id, :general_rating, :metacritic_rating, :esrb_rating, :image, :release_date, :publisher_id, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
