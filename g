#!/usr/local/bin/ruby

WORKING_DIR = Dir.pwd.split("/").last
MY_LOCATION = File.expand_path(__FILE__)

# If we aren't running the most recent file (in dotfiles) and they arent the 
# same then we should update this file.
if File.expand_path(MY_LOCATION) != File.expand_path("~/dotfiles/g") and
  `diff #{File.expand_path MY_LOCATION} #{File.expand_path("~/dotfiles/g")}`!=""
 
  puts "Out of date. Updating."

  # Update the pathed file with the one in ~/dotfiles, then re-run this file.
  `cd ~/dotfiles && ./install && cd #{`pwd`}`
  exec "ruby #{__FILE__}"
end

if ARGV[0] == "s"
  system "ssh-agent bash"
  
  `ssh-add`
end

# What process is running on a given port?
if ARGV[0] == "pf"
  puts `lsof -w -n -i tcp:#{ARGV[1]}`
end

## Directory hopping

if ARGV[0] == "d"
  `cd ~/src`
end

## Causes specific

# Causes app
if ARGV[0] == "cau"
  if WORKING_DIR != "causes"
    puts "This should be run in the causes directory."
    exit 0
  end

  # ENV["FAST"] = true
  exec "bundle exec mongrel_rails start -p 3062"
end

# Spin up Duckweed
if ARGV[0] == "duck"
  if WORKING_DIR != "causes"
    puts "This should be run in the causes directory."
    exit 0
  end

  threads = []

  `sudo redis-server /etc/redis.conf`

  # Run these commands asynchronously so they don't block us from running 
  # duckweed.
  [ "vendor/plugins/async_observer/bin/worker",
    "beanstalkd -d -p 11301", # Would be cool to pull this from config settings.
  ].each do |cmd|
    threads << Thread.new do
      puts "Running #{cmd}"
      `#{cmd}`
    end
  end
  
  exec "cd ../duckweed && rackup config.ru --port 3063" # Another hardcoded port.
end
