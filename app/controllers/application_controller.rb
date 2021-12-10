class ApplicationController < ActionController::Base
     before_action :initialize_session
     helper_method :cart

     private

     def initialize_session
          #this will initialize the visit count to zero for new users.
          session[:shopping_cart] ||= {} #empty array of product IDs
     end

     def cart
          #you can pass an array of ids, and you'll get back a collection!
          Product.find(session[:shopping_cart].keys)
          #pass an array of product id's.. get a collection of products!
     end

     protect_from_forgery with: :exception

     before_action :configure_permitted_parameters, if: :devise_controller?

     protected

          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:user_name, :email, :password, :province_id)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:province_id, :user_name, :email, :password, :current_password)}
          end

end
