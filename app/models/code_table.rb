# -*- encoding : utf-8 -*-
class CodeTable
  def self.parse_file(file)
    book = Spreadsheet.open(file)
    sheet = book.worksheet(0)
    row_results = []
    sheet.each do |row|
      row_hash  = {}
      row_hash[:code] = row[0].to_i
      row_hash[:code_desc] = row[1]
      row_hash[:point] = row[2].to_i
      row_hash[:fine] = row[3].to_i
      row_results << row_hash
    end
    row_results
  end
  
end
