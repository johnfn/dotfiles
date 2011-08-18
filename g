#!/usr/local/bin/ruby

WORKING_DIR = Dir.pwd.split("/").last
MY_LOCATION = File.expand_path(__FILE__)

if File.expand_path(MY_LOCATION) != File.expand_path("~/dotfiles/g") and
  `diff #{File.expand_path MY_LOCATION} #{File.expand_path("~/dotfiles/g")}` != ""
 
  puts "Out of date. Run cd ~/dotfiles && ./install && cd `pwd`."
  exit 0
end

puts "Simple script runner."

if ARGV[0] == "s"
  system "ssh-agent bash"
  
  `ssh-add`
end

## Causes specific

# Causes app
if ARGV[0] == "cau"
  if WORKING_DIR != "causes"
    puts "This should be run in the causes directory."
    exit 0
  end

  `FAST=true bundle exec mongrel_rails start -p 3062`
end

# Spin up Duckweed
if ARGV[0] == "duck"
  if WORKING_DIR != "causes"
    puts "This should be run in the causes directory."
    exit 0
  end

  threads = []

  `sudo redis-server /etc/redis.conf`

  [ "vendor/plugins/async_observer/bin/worker",
  "beanstalkd -d -p 11301", # Would be cool to pull this from config settings.
  "cd ../duckweed && rackup config.ru --port 3063" # Another hardcoded port.
  ].each do |cmd|
    threads << Thread.new do
      puts "Running #{cmd}"
      `#{cmd}`
    end
  end
end
