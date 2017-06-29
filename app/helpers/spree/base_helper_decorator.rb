Spree::BaseHelper.class_eval do

  DEFAULT_THEME_THUMBNAIL_NAME = 'snapshot.png'

  def snapshot_path(theme)
    File.join('/vinsol_spree_themes', theme.name, DEFAULT_THEME_THUMBNAIL_NAME)
  end

end
