require 'test/unit'
require 'rubygems'
require 'action_controller'
require 'action_view' 
require File.dirname(__FILE__) + '/../lib/inputs_with_class' 

# Define the classes I'll be using in the test...
class Pirate 
  attr_accessor :name, :agree, :picture, :secret, :favorite_jewel
end

class Jewel
  attr_accessor :name, :id
end

class InputsWithClassTest < Test::Unit::TestCase 
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormHelper  
  # include the following for supporting form methods (probably a better way)
  include ActionView::Helpers::FormOptionsHelper    # ...to get options_for_select
  include ActionController::RecordIdentifier        # ...form_for
  include ActionController::PolymorphicRoutes       # ...polymorphic_paths
  include ActionView::Helpers::UrlHelper            # ...url_for
  include ActionView::Helpers::TextHelper           # ...concat
   # inject the plugins last to apply overrides
  include LeeWB::Helpers::InputsWithClassHelper 
  
  def setup
    @pirate = Pirate.new 
    
    j1 = Jewel.new
    j1.name = 'ruby'
    j1.id = 1
    
    j2 = Jewel.new
    j2.name = 'emerald'
    j2.id = 2
    
    j3 = Jewel.new
    j3.name = 'pearl'
    j3.id = 3

    @jewels = [j1, j2, j3]
    
    @jewel_options_for_select = options_for_select([ ['ruby','1'],['emerald','2'],['pearl','3']])
  end
  
  def test_should_class_general_tag_builder
    assert_equal '<input class="text" type="text" />', tag('input', {'type' => 'text'})
  end
  
  # FormHelper tests
  
  def test_should_class_text_field
    assert_equal '<input class="text" id="pirate_name" name="pirate[name]" size="30" type="text" />', text_field(:pirate, :name)
  end
  
  def test_should_class_password_field
    assert_equal '<input class="password" id="pirate_secret" name="pirate[secret]" size="30" type="password" />', password_field(:pirate, :secret)
  end
  
  def test_should_class_hidden_field
    assert_equal '<input class="hidden" id="pirate_name" name="pirate[name]" type="hidden" />', hidden_field(:pirate, :name)
  end
  
  def test_should_class_file_field
    assert_equal '<input class="file" id="pirate_picture" name="pirate[picture]" size="30" type="file" />', file_field(:pirate, :picture)
  end
  
  def test_should_class_check_box
    expected =
      '<input class="checkbox" id="pirate_agree" name="pirate[agree]" type="checkbox" value="1" />' +
      '<input class="hidden" name="pirate[agree]" type="hidden" value="0" />'
    assert_equal expected, check_box(:pirate, :agree)
  end
  
  def test_should_class_radio_button
    assert_equal '<input class="radio" id="pirate_agree_1" name="pirate[agree]" type="radio" value="1" />', radio_button(:pirate, :agree, 1)
  end
  
  def test_should_class_text_field_tag_and_include_the_userdefined_class
    assert_equal '<input class="userdefinedclass text" id="name" name="name" type="text" value="somevalue" />', text_field_tag('name', 'somevalue', :class =>'userdefinedclass')
  end
  
  # FormTagHelper tests
  
  def test_should_class_text_field_tag
    assert_equal '<input class="text" id="name" name="name" type="text" />', text_field_tag('name')
  end
  
  def test_should_class_hidden_field_tag
    assert_equal '<input class="hidden" id="name" name="name" type="hidden" />', hidden_field_tag('name')
  end
  
  def test_should_class_file_field_tag
    assert_equal '<input class="file" id="picture" name="picture" type="file" />', file_field_tag('picture')
  end
  
  def test_should_class_password_field_tag
    assert_equal '<input class="password" id="secret" name="secret" type="password" />', password_field_tag('secret')
  end
  
  def test_should_class_check_box_tag
    assert_equal '<input class="checkbox" id="agree" name="agree" type="checkbox" value="1" />', check_box_tag('agree')
  end
  
  def test_should_class_radio_button_tag
    assert_equal '<input class="radio" id="agree_1" name="agree" type="radio" value="1" />', radio_button_tag('agree', 1)
  end
  
  def test_should_class_submit_tag
    assert_equal '<input class="submit" name="commit" type="submit" value="Submit" />', submit_tag('Submit')
  end
  
  def test_should_class_image_submit_tag
    assert_equal '<input class="image" src="/images/button.png" type="image" />', image_submit_tag('button.png')
  end
  
  # Select List Tests
  
  def test_should_class_time_zone_select_single
    output = time_zone_select :to_time_zone, :name 
    assert_output_has_css_class(output, 'time_zone_select single', 'single') 
  end
  
  def test_should_class_time_zone_select_multiple
    output = time_zone_select :from_time_zone, :name, {}, {}, {:multiple => true, :size =>3}
    assert_output_has_css_class(output, 'time_zone_select multiple', 'multiple')
  end
  
  def test_should_class_country_select_single
    output = country_select(:to_country, :name)
    assert_output_has_css_class(output, 'country_select single', 'single')
  end
  
  def test_should_class_country_select_multiiple 
    output = country_select(:from_country, :name, {}, {}, {:multiple => true, :size =>3 })
    assert_output_has_css_class(output, 'country_select multiple', 'multiple')
  end
  
  def test_should_class_select_tag_single
    output = select_tag 'attacks', @jewel_options_for_select
    assert_output_has_css_class(output, 'select_tag for single select', 'single')
  end
  
  def test_should_class_select_tag_multiple
     output = select_tag 'attacks', @jewel_options_for_select, {:multiple => true, :size =>3 }
     assert_output_has_css_class(output, 'select_tag for multiple select', 'multiple')
  end
  
  def test_should_class_content_tag_single
    output = content_tag("select", @jewel_options_for_select)
    assert_output_has_css_class(output, 'content_tag for single select', 'single')
  end
  
  def test_should_class_content_tag_multiple
    output = content_tag("select", @jewel_options_for_select, :multiple => true, :size =>3)
    assert_output_has_css_class(output, 'content_tag for multiple select', 'multiple')
  end
  
  def test_should_class_collection_select_single
    _erbout = ''
    form_for :pirate, @pirate, :url => 'stub', :html => { :class => 'stub', :id => 'stub' } do |f|
      _erbout.concat f.collection_select(:favorite_jewel, @jewels, :id, :name)
    end
    assert_output_has_css_class(_erbout, 'test_collection_select_single', 'single')
  end
  
  def test_should_class_collection_select_multiple
    _erbout = ''
    form_for :pirate, @pirate, :url => 'stub', :html => { :class => 'stub', :id => 'stub' } do |f|
      _erbout.concat f.collection_select(:favorite_jewel, @jewels, :id, :name, {}, {:multiple => true, :size =>3})
    end
    assert_output_has_css_class(_erbout, 'test_collection_select_multi', 'multiple')
  end
  
  def test_should_class_collection_select_single_and_include_the_userdefined_class
    _erbout = ''
    form_for :pirate, @pirate, :url => 'stub', :html => { :class => 'stub', :id => 'stub' } do |f|
      _erbout.concat f.collection_select(:favorite_jewel, @jewels, :id, :name, {}, {:class =>'userdefinedclass'})
    end
    assert_output_has_css_class(_erbout, 'test_collection_select_single', 'userdefinedclass single')
  end

  private

  def protect_against_forgery?
    false
  end
  
  def assert_output_has_css_class(output, from_what, css_class) 
    assert_match(/.class="#{css_class}"/, output, message=" ******* The html output by this helper should CONTAIN the css string: class=\"#{css_class}\"  ******* ")
  end
end
