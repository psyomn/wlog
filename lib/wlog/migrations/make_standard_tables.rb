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
      t.integer :timelog, :limit => 8
      t.text :long_description
    end

    create_table :log_entries do |t|
      t.text :description
      t.integer :issue_id
    end

    create_table :attachments do |t|
      t.text :filename 
      t.text :given_name
      t.blob :data
    end

    create_table :key_values do |t|
      t.text :key
      t.text :value
    end
  end
end
end 


=begin
TODO
-- A polymorphic relationship for attachments. So pretty much anything that
-- wants to have something attached, uses the discriminator in order to 
-- specify itself, as well as its id. 
CREATE TABLE polymorphic_attachments (
  discriminator    TEXT, 
  discriminator_id INTEGER, 
  attachment_id    INTEGER
);

=end
