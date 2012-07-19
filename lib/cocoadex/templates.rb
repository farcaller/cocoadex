module Cocoadex
  module Templates
    MULTIPLE_CHOICES =<<-EOT
<%= Bri::Templates::Helpers.hrule("Multiple choices:") %>

<%= Bri::Renderer.wrap_list( objects.sort ) %>

    EOT

    CLASS_DESCRIPTION =<<-EOT

<%= hrule( type + ": " + name ) %>
<%= print_origin( origin ) %>

<% if description.empty? %>
  (no description...)
<% else %>
<%= '\n' + description %>
<% end %>
<% unless overview.empty? %>
<%= hrule %>

<%= section_header( "Overview:" ) %>
<%= Bri::Renderer.wrap_row(overview.join('\n\n'), Cocoadex.width) %>
<% end %>

<%= hrule %>

<% unless class_methods.empty? %>
<%= section_header( "Class methods:" ) %>
<%= Bri::Renderer.wrap_list( class_methods.sort ) %>


<% end %>
<% unless instance_methods.empty? %>
<%= section_header( "Instance methods:" ) %>
<%= Bri::Renderer.wrap_list( instance_methods.sort ) %>


<% end %>
<% unless properties.empty? %>
<%= section_header( "Properties:" ) %>
<%= Bri::Renderer.wrap_list( properties.sort ) %>


<% end %>
    EOT

    METHOD_DESCRIPTION =<<-EOT

<%= hrule( name ) %>
<%= print_origin( origin ) %>


<%= Cocoadex.trailing_indent(Bri::Renderer.wrap_row(declaration, Cocoadex.width), 2, 6) %>

<% if return_value %>

<%= 'Returns: ' + return_value %>
<% end %>

<%= hrule %>
<% if abstract.empty? %>
  (no description...)
<% else %>
<%= Bri::Renderer.wrap_row(abstract, Cocoadex.width) %>
<% end %>

<% unless parameters.empty? %>
<%= section_header( "Parameters:" ) %>
<% parameters.each do |param| %>

<%= h3(Cocoadex.indent(param.name, 2)).strip %>
<% Bri::Renderer.wrap_row(param.description, Cocoadex.width).split('\n').each do |line| %>
<%= Cocoadex.indent(line, 4) %>
<% end %>
<% end %>


<% end %>
<%= availability %>

    EOT

    PROPERTY_DESCRIPTION =<<-EOT

<%= hrule( name ) %>
<%= print_origin( origin ) %>


<%= Bri::Renderer.wrap_row(declaration, Cocoadex.width) %>
<%= hrule %>
<% if abstract.empty? %>
  (no description...)
<% else %>
<%= Bri::Renderer.wrap_row(abstract, Cocoadex.width) %>
<% end %>

<%= availability %>

    EOT
  end
end

module Bri
  module Templates
    module Helpers
      def h3 text
        Term::ANSIColor::blue + text + Term::ANSIColor::reset + "\n"
      end
      module_function :h3
    end
  end
end
