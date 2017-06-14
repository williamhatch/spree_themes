class AddNameFieldToSpreeThemes < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_themes, :name, :string
  end
end
