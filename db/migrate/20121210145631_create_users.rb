# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.boolean :super_admin, default: false
      t.boolean :allow_login, default: false

      t.timestamps
    end
  end
end
