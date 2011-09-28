class PageBase
  def login_only?
    false
  end

  def no_cache?
    false
  end

  def clear_token?
    true
  end
end
