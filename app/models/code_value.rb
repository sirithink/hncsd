# -*- encoding : utf-8 -*-
class CodeValue < ActiveRecord::Base
  attr_accessible :code, :code_desc, :fine, :point
end
