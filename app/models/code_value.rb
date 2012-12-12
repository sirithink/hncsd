# -*- encoding : utf-8 -*-
class CodeValue < ActiveRecord::Base
  attr_accessible :code, :code_desc, :fine, :point

  def self.import(rows)
    transaction do
      delete_all
      create!(rows)
    end
  end
end
