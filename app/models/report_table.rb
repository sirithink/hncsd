# -*- encoding : utf-8 -*-
class ReportTable
  attr_reader :rows
  def initialize
    @rows = []
  end
  
  def add_record(record)
    row = @rows.find{|r| r.mergeable?(record)}
    if row
      row.merge(record)
    else
      @rows << ReportRow.new(record)
    end
  end

  def add_records(records)
    records.each do |r|
      add_record(r)
    end
  end

  def point_sum
    @rows.sum{|r| r.point_sum}
  end

  def fine_sum
    @rows.sum{|r| r.fine_sum}
  end

  def self.from_records(records)
    table = self.new
    table.add_records(records)
    table
  end
end
