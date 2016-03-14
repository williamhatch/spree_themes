class CreateTableSpreeThemes < ActiveRecord::Migration
  def change
    create_table :spree_themes do |t|
      t.string    :name
    end
    Spree::Theme.create!(name: 'default')
  end
end
