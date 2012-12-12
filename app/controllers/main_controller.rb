# -*- encoding : utf-8 -*-
class MainController < ApplicationController
  skip_before_filter :login_required, only: [:login, :login_auth]

  def login
    render layout: 'app'
  end

  def login_auth
    user = User.authenticate_user(params[:name], params[:password])
    if user.is_a?(User)
      login_user(user)
      flash.notice = '登录成功'
      redirect_to root_path
    else
      flash.alert = '登录失败'
      redirect_to action: :login
    end
  end

  def logout
    logout_user
    redirect_to action: :login
  end

  def index
  end

  def query
    @fields = Agent.fetch_form
    session[:hncsjj_session] = @fields.delete('hncsjj_session')
  end

  def post_query
    if session[:hncsjj_session].nil?
      flash.alert = '请重试'
      redirect_to action: :query
    else
      fields = params.dup
      fields['ctl00$ContentPlaceHolder1$ButtonClwfOk'] = '确定'
      page = Agent.post_form(fields, session[:hncsjj_session])
      page.body.force_encoding('utf-8')
      check_error(page)
      if @error.nil?
        @title, @data = extract_data(page)
        save_unknown_error(page)
      end
      if @error
        flash.now.alert = @error 
        self.query
        render 'query'
      else
        render 'post_query'
      end
    end
  end

  def captcha
    if session[:hncsjj_session].nil?
      render :nothing => true, content_type: Mime::JPEG
    else
      image_io = Agent.fetch_captcha(session[:hncsjj_session])
      send_data(image_io.read, type: Mime::JPEG)
    end
  end

  private
  def check_error(page)
    body = page.body
    if body =~ Regexp.new('你输入的验证码错误，请重新输入')
      @error = "验证码错误，请重新输入"
    elsif  body =~ Regexp.new('没有找到机动车')
      @error = page.search('#labTitle').first.content
    elsif body =~ Regexp.new('违法信息查询错误')
      @error = page.search('#labNoPic').first.content
    elsif body =~ Regexp.new('你访问的页面已经过期')
      @error = "访问过期,请返回首页刷新重试"
    end
  end

  def save_unknown_error(page)
    if @error.nil? && @data.nil?
      @error = "未知错误,请重试或联系技术人员"
      file = File.join(Rails.root, "log/unknown_error_#{Time.now.to_i}.log")
      File.write(file, page.body)
    end
  end

  def extract_data(page)
    data_table = page.search('#gvWZ')
    rows = nil
    title = (page.search('#labTitle').first.content rescue '')
    if data_table.size > 0
      rows = []
      rows << data_table.search('tr').first.search('th').map{|th| th.text} #head
      data_table.search('tr')[1..-1].each do |td_row|
        rows << td_row.search('td').map{|th| th.text}
      end
    end
    [title, rows]
  end

end
