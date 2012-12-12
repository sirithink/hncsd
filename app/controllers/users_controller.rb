# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :admin_required
  before_filter :find_user, only: [:edit, :update, :destroy, :ban]

  def index
    @users = User.order('id DESC').all
  end

  def new
    @user = User.new
    @user.allow_login = true
  end

  def create
    @user = User.new(user_params, without_protection: true)
    if @user.save
      flash.notice = '添加用户成功'
      redirect_to action: :index
    else
      flash.now.alert = "添加用户失败,#{@user.errors.full_messages.join(',')}"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params, without_protection: true)
      flash.notice = '修改用户成功'
      redirect_to action: :edit
    else
      flash.now.alert = "修改用户失败,#{@user.errors.full_messages.join(',')}"
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash.notice = '删除用户成功'
    redirect_to action: :index
  end

  def ban
    if @user.id == current_user.id
      render js: 'alert("不能禁用当前登录帐号");'
    else
      @result = @user.update_attribute(:allow_login, false)
    end
  end

  private
  def user_params
    params[:user].is_a?(Hash) ? params[:user].slice(:name, :password, :super_admin, :allow_login) : {}
  end

  def find_user
    @user = User.find(params[:id])
  end
end
