require 'wlog/domain/static_configurations'
require 'wlog/commands/commandable'
module Wlog
  # After the template is processed, write out the results to standard file.
  # @author Simon Symeonidis
  class WriteTemplate < Commandable
    include StaticConfigurations

    def initialize(template_output, invoice)
      @template_output = template_output
      @invoice = invoice
    end

    def execute
      FileUtils.mkdir_p TemplateOutputDir
      template_ext = File.extname TemplateHelper.template_file || '.txt'
      filename = TemplateOutputDir + "#{@invoice.id}-invoice#{template_ext}"
      File.write(filename, @template_output)
      nil
  end
  end
end
