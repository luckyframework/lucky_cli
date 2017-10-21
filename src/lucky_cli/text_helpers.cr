module LuckyCli::TextHelpers
  def arrow
    "▸"
  end

  def red_arrow
    arrow.colorize(:red)
  end

  def green_arrow
    arrow.colorize(:green)
  end
end
