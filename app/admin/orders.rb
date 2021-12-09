ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :order_no, :payment_amount_no_tax, :GST, :HST, :PST, :payment_total, :pay_date,
                :user_id, product_orders_attributes: [:id, :product_id, :order_id, :quantity, :price, :_destroy]

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs

    f.inputs do
      f.has_many :product_orders, allow_destroy: true do |n_f|
        n_f.input :product
        n_f.input :quantity
        n_f.input :price, hint: n_f.object.price.present? ? "Currently selling for #{n_f.object.price}" : ""
      end
    end

    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    default_main_content

    panel "Products" do

      table_for order.product_orders do
        column "Title" do |productOrder|
          Product.find(productOrder.product.id).name
        end
        column "Quantity" do |productOrder|
          productOrder.quantity
        end
        column "Price" do |productOrder|
          productOrder.price
        end
      end
    end
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:order_no, :payment_amount_no_tax, :GST, :HST, :PST, :payment_total, :pay_date, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
