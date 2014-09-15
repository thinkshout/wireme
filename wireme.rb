#!/usr/bin/ruby

# Wireme - A script for building a Jekyll site ready for wireframing

require 'fileutils'
require 'shell'

# Init a Jekyll site in requested directory

# CD into Jekyll directory and create needed directories and files
# Adds the following:
#   _plugins/
#   _data/
#     pages.yml
#     nav.yml
#     posts.yml
#   assets/
#     sass
#     js
#     css
#     images
#   Rakefile 
#   Gemfile

dir = ""
loop do 
  if dir == "" 
    puts "Where do you want Jekyll to build your site?:"
    dir = gets.chomp
  end
  break if dir != ""
end 

project_name = ""
loop do 
  if project_name == "" 
    puts "Where do you want Jekyll project to be called?:"
    project_name = gets.chomp
  end
  break if project_name != ""
end 

def wireme(dir, project_name)
  # strip trailing slash from directory
  if dir.end_with? "/"
    dir = dir.slice(0...-1)
  end

  # create jekyll project
  puts `cd #{dir} && jekyll new #{project_name}`
  
  project_path = "#{dir}/#{project_name}" 
  # Create directories
  directories = ['_data', 
                 '_plugins',
                 '_includes/global',
                 '_includes/modules',
                 'assets', 
                 'assets/js',
                 'assets/css',
                 'assets/img',
                 'assets/sass',
                 'assets/sass/modules',
                 'assets/sass/layouts']
  
  directories.each do |dir|
    puts `mkdir #{project_path}/#{dir}`
    puts "Created directory: #{dir}"
  end 
  
  # Create files
  files = ['Gemfile', 'Rakefile', 'config.rb']

  files.each do |file|
    puts `touch #{project_path}/#{file}`
    puts "Created file: #{file}"
  end
  
  # Create Sass config file
  puts 'Creating config.rb'
  puts `touch #{project_path}/config.rb`
  puts `echo 'require "breakpoint"' >> #{project_path}/config.rb`
  puts `echo 'require "sass-globbing"' >> #{project_path}/config.rb`
  puts `echo 'http_path = "assets/"' >> #{project_path}/config.rb`
  puts `echo 'css_dir = "assets/css"' >> #{project_path}/config.rb`
  puts `echo 'sass_dir = "assets/sass"' >> #{project_path}/config.rb`
  puts `echo 'images_dir = "assets/images"' >> #{project_path}/config.rb`
  puts `echo 'javascripts_dir = "assets/js"' >> #{project_path}/config.rb`
  
  # Add Gemfile dependencies and run bundler
  puts `echo 'source "https://rubygems.org"' >> #{project_path}/Gemfile`
  gems = ['gem "bourbon"', 
          'gem "neat"', 
          'gem "bitters"', 
          'gem "sass","3.4.2"', 
          'gem "sass-globbing", "1.1.1"', 
          'gem "breakpoint", "2.5.0"']

  gems.each do |gem|
    puts `echo '#{gem}' >> #{project_path}/Gemfile`
    puts "added #{gem} to Gemfile"
  end
  
  # Install gems from Gemfile
  puts `cd #{project_path} && bundle install`

  # Install bourbon and neat in the sass directory
  puts `cd #{project_path}/assets/sass && bundle exec bourbon install`
  puts `cd #{project_path}/assets/sass && bundle exec neat install`
  puts `cd #{project_path}/assets/sass && bundle exec bitters install`
  
  # Download normalize.scss
  #puts `cd #{project_path}/assets/css && curl -o --url 'http://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css' --max-time 10000`
  
  # Create style.scss and add imports
  puts `cd #{project_path}/assets/sass && touch style.scss`
  puts `echo '@import "bourbon/bourbon" >> style.scss`
  puts `echo '@import "neat/neat" >> style.scss`
  puts `echo '@import "base/base" >> style.scss`
  puts `echo '@import "layouts/*" >> style.scss`
  puts `echo '@import "modules/*" >> style.scss`

end

wireme(dir, project_name)
