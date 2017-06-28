Deface::Override.new(
  virtual_path: 'spree/admin/shared/_main_menu',
  name: 'add_themes_tab',
  insert_before: 'div.spree-version',
  partial: 'spree/admin/shared/theme_menu_button'
)
