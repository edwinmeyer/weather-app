module ApplicationHelper
  def displayable_locale(name, country)
    (name || country).present? ? "#{name}, #{country}" : ''
  end
end
