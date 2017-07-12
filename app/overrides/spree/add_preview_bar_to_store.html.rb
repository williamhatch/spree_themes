Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'add_preview_bar_to_store',
  insert_before: '[data-hook="body"]',
  partial: 'spree/shared/preview_bar'
)
