class Dir

  def self.human_entries(path)
    Dir.entries(path).reject{ |_path| (_path == '.' || _path == '..') }
  end

end
