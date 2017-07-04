Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'add_theme_meta_details_to_store',
  insert_bottom: '[data-hook="inside_head"]',
  partial: 'spree/shared/theme_metadata'
)
