class ChangeDataTypeThemeTemplates < ActiveRecord::Migration[4.2]
  def change
      change_column :spree_themes_templates, :body, :longtext
    end
  end
end
