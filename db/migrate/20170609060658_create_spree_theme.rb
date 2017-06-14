class CreateSpreeTheme < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_themes do |t|
      t.attachment :template_file
    end
  end
end
