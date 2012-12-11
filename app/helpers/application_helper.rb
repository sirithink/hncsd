# -*- encoding : utf-8 -*-
module ApplicationHelper
  def render_nav_link(name, link)
    li_class = ''
    li_class = 'active' if current_page?(link)
    content_tag(:li, class: li_class ) do
      link_to name, link
    end
  end
end
