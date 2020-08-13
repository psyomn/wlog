require 'active_record'

module Wlog
  # Migrations to replace the raw sql from turntables
  # @author Simon Symeonidis
  class MakeStandardTables < ActiveRecord::Migration
    def change
      create_table :issues do |t|
        t.text :description
        t.datetime :due_date
        t.integer :status
        t.integer :timelog, limit: 8
        t.text :long_description
        t.datetime :created_at
        t.datetime :updated_at
      end

      create_table :log_entries do |t|
        t.text :description
        t.integer :issue_id
        t.datetime :created_at
        t.datetime :updated_at
      end

      create_table :attachments do |t|
        t.text :filename
        t.text :given_name
        t.text :data
        t.datetime :created_at
        t.datetime :updated_at
      end

      create_table :key_values do |t|
        t.text :key
        t.text :value
      end

      create_table :invoices do |t|
        t.datetime :from
        t.datetime :to
        t.text :description
      end
    end
  end
end
