require 'active_record'

module Wlog
# Add type, id polymorphic fields
# @author Simon Symeonidis
# @date Sun Oct  5 22:43:12 EDT 2014
class FixAttachmentsPolymorphicTable < ActiveRecord::Migration

  def change
    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attachable_type, :text
  end

end
end
