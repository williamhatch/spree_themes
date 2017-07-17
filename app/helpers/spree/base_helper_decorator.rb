Spree::BaseHelper.class_eval do

  DEFAULT_THEME_THUMBNAIL_NAME = 'snapshot.png'
  INVALID_DIRECTORIES = ['.', '..', 'precompiled_assets', 'images', 'fonts']

  def snapshot_path(theme)
    File.join('/vinsol_spree_themes', theme.name, DEFAULT_THEME_THUMBNAIL_NAME)
  end

  def sorted_themes(themes)
    themes.sort { |a, b| Spree::Theme::STATES.index(b.state) <=> Spree::Theme::STATES.index(a.state) }
  end

  # FIX_ME_PG:- This helper method needs to be defined here as it is used by spree_auth_devise extension templates.
  # spree_auth_devise not able to load the helper method from the store_controller.
  def preview_mode?
    current_spree_user.present? && current_spree_user.admin? && session[:preview].present?
  end

  # FIX_ME_PG:- Optimize the logic for building the directory files tree strucutre.
  def display_filetree_structure(theme, path, name=nil)
    html_string ||= ''
    html_string << '<ul>'

    Dir.foreach(path) do |entry|
      next if INVALID_DIRECTORIES.include?(entry)
      full_path = File.join(path, entry)

      if File.directory?(full_path)
        html_string << "<li><a href='javascript:void(0)'>#{ entry }</a>"
        html_string << "#{ display_filetree_structure(theme, full_path, entry) }"
      else
        # FIX_ME_PG:- Currently need to load the template for every filepath on basis of path and name.
        template_path = File.dirname(full_path.sub(Rails.root.to_s + '/', ''))
        template = theme.templates.find_by(path: template_path, name: entry)
        next unless template
        html_string << "<li>#{ link_to entry, edit_admin_theme_template_path(theme, template), remote: true, class: 'file-link' }</li>"
      end
    end
    html_string << '</ul>'

    return html_string
  end

end
