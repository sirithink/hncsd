# -*- encoding : utf-8 -*-
require 'test_helper'

class CodeTableTest < ActiveSupport::TestCase
  test "#parse_file 应该不报错" do
    assert_nothing_raised do
      file = get_mock_file
      CodeTable.parse_file(file)
    end
  end

  test "#parse_file 应该返回一个Hash Array" do
      file = get_mock_file
      rows = CodeTable.parse_file(file)
      assert rows.is_a?(Array)
      assert_equal 2, rows.size
      row = rows.first
      assert_equal 4, row.size
      assert_equal 30020, row[:code]
      assert_equal '行人不服从交警指挥的', row[:code_desc]
      assert_equal 0, row[:point]
      assert_equal 20, row[:fine]
  end

  private
  def get_mock_file
    File.join(Rails.root, 'test/fixtures/mock_code.xls')   
  end
end
