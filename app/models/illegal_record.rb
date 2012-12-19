# -*- encoding : utf-8 -*-
class IllegalRecord
  FIELDS = [:license_number, :illegal_time, :illegal_sites, :illegal_code, :illegal_act,
    :fines, :data_sources, :handle_time, :handle_mark, :office_code, :office]
  #           驾驶证号          违法时间       违法地点        违法代码       违法行为
  # 罚款金额 数据来源       处理时间      处理标记      发现机关代码  发现机关
  attr_accessor(*FIELDS)
  EFFECTIVE_START_TIME = Time.new(2011,3,26)

  private_class_method :new
  def self.new_record(row)
      illegal_record = self.send(:new)
      FIELDS.each_with_index do |field, index|
        illegal_record.send("#{field}=", row[index])
      end
      illegal_record
  end

  def self.from_rows(rows)
    records = []
    rows.each do |row|
      records << new_record(row)
    end if rows.respond_to? :each
    records
  end

  def office_slug_name
    "#{office_code}-#{office_city_name}"
  end

  def office_city_name
    if office_code.strip == '湘Z'
      '高速'
    elsif office =~ /机场/
      '机场'
    else
      office.split(/(交警|公安)/).first
    end
  end

  def to_array
    values = []
    FIELDS.each do |field|
      values << self.send(field)
    end
    values
  end

  def code_value
    CodeValue.find_by_code(illegal_code)
  end

  def point
    code_value.try(:point)
  end

  def final_point
    if Time.parse(illegal_time) > EFFECTIVE_START_TIME
      point
    else
      0
    end
  end

  def fine
    code_value.try(:fine)
  end

  def judgement
    handle_mark.strip != '未处理' ? '裁决'  : ''
  end
end
