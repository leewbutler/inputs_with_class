# InputsWithClassHelper adds it functionality to existing Rails helpers in three ways: 
#
#     1. Opens the module ActionView::Helpers::TagHelper and employs alias_method_chain to add functionality to its 'tag' method.
#
#     2. Opens the class InputsWithClass::Helpers::InputsWithClassHelper and employs alias_method_chain to add functionality to its 'tag' method.
#
#     3. An existing alias_method does not allow us to use the technique for the 5 remaining html selection helpers so 
#        instead we overide each of the 5 helper calls, add the functionality, then pass the call on to its origional handler.
#
#
# For a good discussion of these two techniques see the following links.
# 
# http://webjazz.blogspot.com/2007/09/diving-into-rails-source-and-explaining.html
# 
# http://rubylearning.com/satishtalim/ruby_overriding_methods.html

module LeeWB #:nodoc:
  module Helpers #:nodoc:
    module InputsWithClassHelper 
      
      # Allows a css class prefix to be added in config/environment.rb
      INPUTS_WITH_CLASS_PREFIX = '' unless defined?(INPUTS_WITH_CLASS_PREFIX)
      
      def input_classing(name, options) 
        options = options.stringify_keys
        if name.to_s == 'input' && options.include?('type')
          options = add_cssclass(options['type'],  options)
        end
        options 
      end
      
      # == RAILS SELECT LIST HELPERS 
      
      # Overrides origional method call from vendor/rails/actionpack/lib/action_view/helpers/form_options_helper.rb, line 83
      def select(object, method, choices, options = {}, html_options = {})
        html_options = add_cssclass_for_select(html_options)
        super
      end 

      ## Overrides origional method call from vendor/rails/actionpack/lib/action_view/helpers/form_options_helper.rb, line 117
      def collection_select(object, method, collection, value_method, text_method, options = {}, html_options = {})
        html_options = add_cssclass_for_select(html_options)
        super
      end

      # Overrides origional method call from vendor/rails/actionpack/lib/action_view/helpers/form_options_helper.rb, line 134
      def time_zone_select(object, method, priority_zones = nil, options = {}, html_options = {})
        html_options = add_cssclass_for_select(html_options)
        super
      end

      # Overrides origional method call from vendor/rails/actionpack/lib/action_view/helpers/form_options_helper.rb, line 122
      def country_select(object, method, priority_countries = nil, options = {}, html_options = {})
        html_options = add_cssclass_for_select(html_options)
        super
      end

      # Overrides origional method call from vendor/rails/actionpack/lib/action_view/helpers/tag_helper.rb, line 66
      def content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
        if name.to_s == 'select'
          options = add_cssclass_for_select(options)
        end
        super
      end
      
      private
      
      def add_cssclass(cssclass, options) 
        if options['class'] == false # ...allows explicit canceling of css classing
          options['class'] = nil
        else
          options['class'] = options.has_key?('class') ? (' ' + INPUTS_WITH_CLASS_PREFIX + cssclass) : (INPUTS_WITH_CLASS_PREFIX + cssclass)
        end
        options
      end
      
      def add_cssclass_for_select(options={})
        options = {} if options == nil
        options = options.stringify_keys 
        if options['class'] == false # ...allows explicit canceling of css classing
          options['class'] = nil
        else 
          options = options.has_key?('multiple') ? add_cssclass('multiple', options) : add_cssclass('single', options) 
        end
        options
      end
      
    end
  end
end
 
module ActionView #:nodoc:
  module Helpers #:nodoc:
    module TagHelper #:nodoc: 
      
      def tag_with_input_classing(name, options = nil, open = false, escape = true) #:nodoc:
        tag_without_input_classing(name, input_classing(name, options), open, escape)
      end
      alias_method_chain :tag, :input_classing
      
    end
    
    class InstanceTag #:nodoc:
      include LeeWB::Helpers::InputsWithClassHelper
      
      def tag_with_input_classing(name, options) #:nodoc:
        tag_without_input_classing(name, input_classing(name, options))
      end
      alias_method_chain :tag, :input_classing
    end
    
  end
end 
ActionController::Base.class_eval do
  helper LeeWB::Helpers::InputsWithClassHelper
end
