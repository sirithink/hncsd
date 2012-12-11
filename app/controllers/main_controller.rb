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
end
