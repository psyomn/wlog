module Wlog
# Interface that CLUIs need to follow (purely command pattern)
# @author
class UiCommand
  def execute
    throw NotImplementedException
  end
end
end
