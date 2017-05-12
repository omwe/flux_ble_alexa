#!/usr/bin/env ruby
# This script is executed as a daemon to run the python scripts to turn the lights on or off
light_on_script = "/home/pi/ble/exe/light_on"
light_off_script = "/home/pi/ble/exe/light_off"

# The scripts already run with python as shebang
if ARGV.first == "on"
    `#{light_on_script}`
else
    `#{light_off_script}`
end
