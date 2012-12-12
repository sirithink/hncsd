# -*- encoding : utf-8 -*-
class ImportCodesController < ApplicationController
  before_filter :admin_required

  def new
  end

  def import
    if params[:file]
      rows = CodeTable.parse_file(params[:file].path)
      CodeValue.import(rows)
      flash.notice = '导入成功'
      redirect_to action: :index
    else
      flash.alert = '请选择要上传的违法代码表'
      redirect_to action: :index
    end
  end

  def index
    @codes = CodeValue.order('code ASC').all
  end
end
