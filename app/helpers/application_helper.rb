module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title
    base_title = t "namepage"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def flash_bg_color message_type
    case message_type.to_sym
    when :success then "bg-green-500"
    when :alert then "bg-red-500"
    when :info then "bg-blue-500"
    when :warning then "bg-yellow-500"
    else "bg-gray-500"
    end
  end
end
