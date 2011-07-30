class PageBase
    def login_only
        return false
    end

    def no_cache
        return false
    end

    def clear_token
        return true
    end
end
