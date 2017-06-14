class CreateSpreeThemesTemplate < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_themes_templates do |t|
      t.text :body
      t.string :path
      t.string :format
      t.string :locale
      t.string :handler
      t.boolean :partial, default: false

      t.timestamps
    end
  end
end
