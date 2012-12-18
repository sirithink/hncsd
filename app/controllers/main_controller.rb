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
      fields = params.slice( *params.keys.select{|k| k =~ /^(ctl00|__)/} )
      fields['ctl00$ContentPlaceHolder1$ButtonClwfOk'] = '确定'
      page = Agent.post_form(fields, session[:hncsjj_session])
      query_result = QueryResult.new(page)
      if query_result.error
        flash.now.alert = query_result.error 
        self.query
        render 'query'
      else
        @title, @heads, @illegal_records = query_result.data
        @report_table = ReportTable.from_records(@illegal_records)
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
end
