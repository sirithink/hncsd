# -*- encoding : utf-8 -*-
class CreateCodeValues < ActiveRecord::Migration
  def change
    create_table :code_values do |t|
      t.integer :code
      t.string :code_desc
      t.integer :fine
      t.integer :point

      t.timestamps
    end
  end
end
