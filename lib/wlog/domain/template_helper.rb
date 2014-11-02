require 'wlog/domain/key_value'
require 'wlog/domain/static_configurations'

module Wlog
# Bunlde helper functions for templates here
# @author Simon Symeonidis
class TemplateHelper
  include StaticConfigurations
  # @return absolute path to the template the user has set
  def self.template_file
    num = KeyValue.get('template') || 1
    Dir[TemplateDir + '*'][num.to_i - 1]
  end

  # @return template contents of the current selected template
  def self.template_s
    File.read(TemplateHelper.template_file)
  end

end
end
