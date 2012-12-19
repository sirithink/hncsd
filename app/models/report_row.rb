# -*- encoding : utf-8 -*-
class ReportRow
  attr_reader :office_slug_name, :fine, :number, :point_sum, :judgement
  def initialize(record)
    @office_slug_name = record.office_slug_name
    @fine = record.fine
    @number = 1
    @point_sum = record.final_point
    @judgement = record.judgement
  end

  def mergeable?(record)
    @office_slug_name == record.office_slug_name &&
      @judgement == record.judgement && @fine == record.fine
  end

  def merge(record)
    if mergeable?(record)
      @number += 1
      @point_sum += record.final_point
    else
      raise '非法合并'
    end
  end

  def fine_sum
    @fine * @number
  end
end
