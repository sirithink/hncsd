# -*- encoding : utf-8 -*-
module MainHelper
  def render_judgement(row)
    if row.judgement.blank?
      ''
    else
      "-#{content_tag(:span, row.judgement, class: 'text-warning') }".html_safe
    end
  end
end
