class AddEnabledToSpreeTheme < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_themes, :enabled, :boolean, default: false
  end
end
