require 'wlog/commands/commandable'
require 'wlog/domain/static_configurations'

module Wlog
  # To check if template dir exists or not. Make dirs. Add sample template.
  # @author Simon Symeonidis
  class BootstrapTemplates < Commandable
    include StaticConfigurations

    def initialize; end

    def execute
      FileUtils.mkdir_p TemplateDir unless File.exist? TemplateDir

      write_default_template! unless File.exist? TemplateSampleFile
    end

    private

    # Write a default template
    def write_default_template!
      fh = File.open(TemplateSampleFile, 'w')
      data = "A list of issues:
<p> Invoice: <%= @invoice.description %> </p>
<p> From: <%= @invoice.from.strftime(\"%A %d %B \") %>  </p>
<p> To: <%= @invoice.to.strftime(\"%A %d %B\") %> </p>
<p> Work Items to report: <%= @log_entries.count %> </p>

<% @issues.each do |issue| %>
  <%= \"\#{issue.id}  \#{issue.description}\" %>
<% end %>"
      fh.write(data)
      fh.close
      nil
  end
  end
end
