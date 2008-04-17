
desc "Copies the input_classes.css starter stylesheet to your /public/stylesheets/ directory."
task :inputs_with_class_css do 
  template =    File.expand_path(File.join(File.dirname(__FILE__), '../stylesheets/inputs_with_class.css'))
  destination = File.expand_path(File.join(File.dirname(__FILE__), '../../../../public/stylesheets/inputs_with_class.css'))
  if File.exist?(destination)
     puts "Oops! Please delete or rename your existing '/public/stylesheets/inputs_with_class.css' file first." 
  else
    require 'fileutils.rb' 
    FileUtils.copy( template, destination)
    puts "Added 'inputs_with_class.css' to your /public/stylesheets/ directory." 
  end
end