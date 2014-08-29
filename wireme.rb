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

puts "Enter a the directory where you want to build:"
dir = gets.chomp
puts "Enter a name the for your project:"
project_name = gets.chomp


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
                 'assets/sass']
  
  directories.each do |dir|
    puts `mkdir #{project_path}/#{dir}`
    puts "Created directory: #{dir}"
  end 
  
  # Create files
  files = ['Gemfile', 'Rakefile']

  files.each do |file|
    puts `touch #{project_path}/#{file}`
    puts "Created file: #{file}"
  end
  
  # Add Gemfile dependencies and run bundler
  puts `echo 'source "https://rubygems.org"' >> #{project_path}/Gemfile`
  gems = ['gem "bourbon"', 'gem "neat"', 'gem "bitters"', 'gem "sass","3.4.2"']
  gems.each do |gem|
    puts `echo '#{gem}' >> #{project_path}/Gemfile`
    puts "added #{gem} to Gemfile"
  end
  
  # Install gems from Gemfile
  puts `cd #{project_path} && bundle install`

  # Install bourbon and neat in the sass directory
  puts `cd #{project_path}/assets/sass && bourbon install && neat install`
end

wireme(dir, project_name)
