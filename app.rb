#coding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'
require './lib/agent'

class App < Sinatra::Base
  set :sessions, true
  set :logging, true
  configure :development do
    register Sinatra::Reloader
  end
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  get '/' do
    home_page
  end

  post '/' do
    return redirect(to('/')) if session[:hncsjj_session].nil?

    fields = params.dup
    fields['ctl00$ContentPlaceHolder1$ButtonClwfOk'] = '确定'
    page = Agent.post_form(fields, session[:hncsjj_session])
    page.body.force_encoding('utf-8')

    check_error(page)

    if @error.nil?

      @title, @data = extract_data(page)

      save_unknown_error(page)
    end

    @error ? home_page : erb(:result)
  end

  get '/captcha' do
    content_type :jpeg
    if session[:hncsjj_session].nil?
      StringIO.new
    else
      Agent.fetch_captcha(session[:hncsjj_session])
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
      file = File.expand_path("../log/unknown_error_#{Time.now.to_i}.log", __FILE__)
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

  def home_page
    @fields = Agent.fetch_form
    session[:hncsjj_session] = @fields.delete('hncsjj_session')
    erb :index
  end
end
