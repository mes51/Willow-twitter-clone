module Convert
  NUMBER = [
    "〇",
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "七",
    "八",
    "九"
  ]

  CLASS = [
    "",
    "十",
    "百"
  ]

  def self.to_jp_num num, show_class
    if (show_class && num >= 1000)
      raise ArgumentError
    end

    result = ""
    if show_class
      CLASS.each do |c|
        t = num % 10
        if c.length > 0
          if t > 1
            result = NUMBER[t] + c + result
          elsif t > 0
            result = c + result
          end
        else
          result = NUMBER[t] + result
        end
        num /= 10
      end
    else
      while true
        is_end = num < 10
        result = NUMBER[num % 10] + result
        num /= 10
        if num == 0 && is_end
          break
        end
      end
    end

    result
  end
end
