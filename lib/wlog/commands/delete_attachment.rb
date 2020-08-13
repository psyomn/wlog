require 'wlog/commands/commandable'
module Wlog
  # Delete an attachment, given its id (in the context of an issue)
  # @author Simon Symeonidis
  class DeleteAttachment < Commandable
    def initialize(issue, att_id)
      @issue  = issue
      @att_id = att_id
    end

    def execute; end

    private
  end
end
