class AddNameToSpreeThemesTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_themes_templates, :name, :string
  end
end
