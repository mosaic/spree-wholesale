module WholesaleHelper
  def price_type
    'wholesale' if @order.user and @order.user.is_wholesale_user?
  end
end
