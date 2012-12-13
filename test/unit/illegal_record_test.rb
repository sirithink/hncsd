# -*- encoding : utf-8 -*-
require 'test_helper'

class IllegalRecordTest < ActiveSupport::TestCase
  test "::form_rows 应该返回一个对象数组" do
    rows = mock_rows
    illegal_records =  IllegalRecord.from_rows(rows)
    assert illegal_records.is_a?(Array)

    record = illegal_records.first
    assert record.is_a?(IllegalRecord)
    assert_equal "湘A", record.office_code
  end

  private
  def mock_rows
    [[" ", "2011-06-28 11:55:13.0", "长沙市解放路/黄兴路（原司门口）", "1344", "机动车违反禁令标志指示的", "(以当地支队为准)", "电子监控", " ", "未处理", "湘A", "长沙市交警支队电子警察大队"],
      [" ", "2011-10-01 15:45:00.0", "潭邵高速九华段", "13031", "机动车行驶超过规定时速20%以下的", "(以当地支队为准)", "电子监控", " ", "未处理", "湘C", "湘潭市公安局交通警察支队科技科"]]
  end
end
