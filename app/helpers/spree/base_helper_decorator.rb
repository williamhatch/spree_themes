Spree::BaseHelper.class_eval do

  DEFAULT_THEME_THUMBNAIL_NAME = 'snapshot.png'

  def snapshot_path(theme)
    File.join('/vinsol_spree_themes', theme.name, DEFAULT_THEME_THUMBNAIL_NAME)
  end

  def sorted_themes(themes)
    themes.sort { |a, b| Spree::Theme::STATES.index(b.state) <=> Spree::Theme::STATES.index(a.state) }
  end

end
