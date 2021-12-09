ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :user_name, :province_id
  #
  # or

  show do
    default_main_content

    panel "Orders" do

      table_for user.orders do
        column "Order no" do |order|
          link_to order.order_no, admin_order_path(order.id)
        end
        column "Subtotal" do |order|
          order.payment_amount_no_tax
        end
        column "Total" do |order|
          order.payment_total
        end
        column "GST Amount no" do |order|
          order.GST
        end
        column "PST Amount" do |order|
          order.PST
        end
        column "HST Amount" do |order|
          order.HST
        end
        column "Pay Date" do |order|
          order.pay_date
        end
      end
    end
  end
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :user_name, :province_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
