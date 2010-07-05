module Wholesale::ProductsHelper
  def self.included(target)
    target.class_eval do
      def product_price(product_or_variant, options={})
        options.assert_valid_keys(:format_as_currency, :show_vat_text)
        options.reverse_merge! :format_as_currency => true, :show_vat_text => Spree::Config[:show_price_inc_vat]
        if (!current_user.nil? && current_user.has_role?("wholesale") && !product_or_variant.wholesale_price.blank?)          
          amount = product_or_variant.wholesale_price
        else
          amount = product_or_variant.price
        end
        amount += Calculator::Vat.calculate_tax_on(product_or_variant) if Spree::Config[:show_price_inc_vat]
        options.delete(:format_as_currency) ? format_price(amount, options) : ("%0.2f" % amount).to_f
      end
    end
  end
end