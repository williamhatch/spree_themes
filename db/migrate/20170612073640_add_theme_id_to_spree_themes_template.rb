class AddThemeIdToSpreeThemesTemplate < ActiveRecord::Migration[5.0]
  def change
    add_reference :spree_themes_templates, :theme, index: true
  end
end
