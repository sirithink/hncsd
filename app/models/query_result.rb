# -*- encoding : utf-8 -*-
class QueryResult
  attr_reader :page, :error, :data
  def initialize(page)
    @page = page
    @page.body.force_encoding('utf-8')

    check_error
    extract_data
    save_unknown_error
  end

  private
  def check_error
    body = @page.body
    if body =~ Regexp.new('你输入的验证码错误，请重新输入')
      @error = "验证码错误，请重新输入"
    elsif  body =~ Regexp.new('没有找到机动车')
      @error = @page.search('#labTitle').first.content
    elsif body =~ Regexp.new('违法信息查询错误')
      @error = @page.search('#labNoPic').first.content
    elsif body =~ Regexp.new('你访问的页面已经过期')
      @error = "访问过期,请返回首页刷新重试"
    end
  end

  def extract_data
    data_table = @page.search('#gvWZ')
    rows = heads = nil
    title = (@page.search('#labTitle').first.content rescue nil)
    if data_table.size > 0
      rows = []
      heads = data_table.search('tr').first.search('th').map{|th| th.text} #head
      data_table.search('tr')[1..-1].each do |td_row|
        rows << td_row.search('td').map{|th| th.text}
      end
    end
    illegal_records = IllegalRecord.from_rows(rows)
    @data = [title, heads, illegal_records]
  end

  def save_unknown_error
    if @error.nil? && @data.first.nil?
      @error = "未知错误,请重试或联系技术人员"
      file = File.join(Rails.root, "log/unknown_error_#{Time.now.to_i}.log")
      File.write(file, @page.body)
    end
  end
end
