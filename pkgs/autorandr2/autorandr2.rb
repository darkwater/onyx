require 'xrandr'
require "#{ENV["HOME"]}/.config/autorandr2/setups.rb"

# example config:
# SETUPS = [
#   {
#     name: "normal",
#     auto: true,
#     enabled: [ "DisplayPort-1", "DisplayPort-0" ],
#     config: {
#       "DisplayPort-1" => { mode: "1920x1080", pos: "0x0",    rate: 120 },
#       "DisplayPort-0" => { mode: "1920x1080", pos: "1920x0", rate: 120 },
#     },
#   },
#   {
#     name: "normal_tvmirror",
#     enabled: [ "DisplayPort-1", "DisplayPort-0", "HDMI-A-0" ],
#     config: {
#       "DisplayPort-1" => { mode: "1920x1080", pos: "0x0",    rate: 120 },
#       "DisplayPort-0" => { mode: "1920x1080", pos: "1920x0", rate: 120 },
#       "HDMI-A-0"      => { mode: "1920x1080", pos: "1920x0", rate: 120 },
#     },
#   },
#   {
#     name: "single",
#     enabled: [ "DisplayPort-0" ],
#     config: {
#       "DisplayPort-0" => { mode: "1920x1080", pos: "0x0", rate: 120 },
#     },
#   },
#   {
#     name: "single_tvmirror",
#     enabled: [ "DisplayPort-0", "HDMI-A-0" ],
#     config: {
#       "DisplayPort-0" => { mode: "1920x1080", pos: "0x0", rate: 120 },
#       "HDMI-A-0"      => { mode: "1920x1080", pos: "0x0", rate: 120 },
#     },
#   },
#   {
#     name: "winbox",
#     auto: true,
#     enabled: [ "DisplayPort-1" ],
#     disconnected: [ "DisplayPort-0" ],
#     config: {
#       "DisplayPort-1" => { mode: "1920x1080", pos: "0x0", rate: 120 },
#     },
#     synergy: true,
#     scream: true,
#   },
#   {
#     name: "tv",
#     enabled: [ "HDMI-A-0" ],
#     config: {
#       "DisplayPort-1" => { mode: "1920x1080", pos: "0x0", rate: 120 },
#     },
#     synergy: true,
#     scream: true,
#   },
# ]

$change = ARGV.include? "-c"
$force = ARGV.include? "-f" # configures screens even if wanted configuration already seems active
$verbose = ARGV.include? "-v"
$list = ARGV.include? "-l"

$wanted = ARGV.reject { |s| s.start_with? "-" }.first

xrandr = Xrandr::Control.new

sorted = SETUPS
  .sort_by { |s| [ -s[:enabled].length, -(s[:disconnected] or []).length ] }

current = sorted
  .find { |s|
    a = s[:enabled].sort == xrandr.outputs
      .reject { |c| c.position.nil? }
      .map { |c| c.name }
      .sort
    b = (s[:disconnected] or []).all? { |name| not xrandr.find_output(name).connected }
    a and b
  }

if $wanted.nil?
  wanted = sorted
    .filter { |s| s[:auto] }
    .sort_by { |s| [ -s[:enabled].length, -(s[:disconnected] or []).length ] }
    .find { |s|
      a = (s[:enabled]      or []).all? { |name|     xrandr.find_output(name).connected }
      b = (s[:disconnected] or []).all? { |name| not xrandr.find_output(name).connected }
      a and b
    }
else
  wanted = SETUPS.find { |s| s[:name] == $wanted }
  throw "unknown setup %s" % $wanted if wanted.nil?
end

if $verbose
  puts "current:"
  pp current
  puts "wanted:"
  pp wanted
end

if current != wanted and not $force
  wanted[:config].each do |name, conf|
    xrandr.configure(name, conf)
  end

  xrandr.outputs
    .reject { |c| c.position.nil? }
    .reject { |c| wanted[:config].has_key? c.name }
    .each do |c|
      xrandr.configure(c.name, off: true)
    end
end

if $change
  if xrandr.command == "xrandr"
    puts "already on %s" % wanted[:name]
  else
    puts "%s -> %s" % [ (current[:name] rescue "<unknown>"), wanted[:name] ]
    puts xrandr.command if $verbose
    xrandr.apply!

    system "systemctl --user restart polybar"
    system "systemctl --user #{wanted[:synergy] ? "start" : "stop"} synergy"
    system "systemctl --user #{wanted[:scream] ? "start" : "stop"} scream"
  end

  $did_something = true
end

if $list
  puts (SETUPS.map do |s|
    a = (s == current) ? "*" : " "
    b = (s == wanted)  ? "+" : " "
    "%s%s%s" % [ a, b, s[:name] ]
  end)

  $did_something = true
end

if not $did_something
  puts <<EOF
usage: autorandr2 [-v] [-c [-f]] [-l] [setup_name]
  -v    verbose output
  -c    change automatically to a setup
  -f    force configure setup even if wanted already seems current
  -l    list setups
EOF
end
