class AddStateToSpreeThemes < ActiveRecord::Migration[5.0]

  def up
    remove_column :spree_themes, :enabled
    add_column :spree_themes, :state, :string
  end

  def down
    add_column :spree_themes, :enabled, :boolean, default: false
    remove_column :spree_themes, :state
  end

end
