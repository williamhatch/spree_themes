class AddMaximumRetailPriceToVariant < ActiveRecord::Migration
  def up
    add_column :spree_variants, :maximum_retail_price, :decimal, scale: 8, precision: 2, default: 0
    Spree::Variant.all.each do |variant|
      variant.update_column(:maximum_retail_price, variant.price)
    end
  end

  def down
    remove_column :spree_variants, :maximum_retail_price, :decimal, scale: 8, precision: 2, default: 0
  end

end
