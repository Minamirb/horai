module ApplicationHelper
end

module ActionView
  module Helpers
    module FormHelper
      def file_field(object_name, method, options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("file", options)
      end
    end
  end
end

