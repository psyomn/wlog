class StandardDb < ActiveRecord::Migration
  def change
    create_table :issues do |t| 
      t.column :description,      :text
      t.column :reported_date,    :integer
      t.column :due_date,         :integer
      t.column :status,           :integer
      t.column :timelog,          :bigint
      t.column :long_description, :text
    end

    create_table :log_entries do |t|
      t.column :description, :text
      t.column :date, :datetime
      t.column :issue_id, :integer
    end

    create_table :attachments do |t| 
      t.column :filename, :text
      t.column :given_name, :text
      t.column :data, :blob
    end

    create_table :key_values do |t|
      t.column :key, :text
      t.column :value, :text
    end

    create_table :polymorphic_attachments do |t| 
      t.column :discriminator, :text
      t.column :discriminator_id, :integer
      t.column :attachment_id, :integer
    end
  end
end
