#!/usr/bin/env ruby

require 'daemons'
options = {
    :log_output => true
}

python_light_runner_file = File.join( File.expand_path( File.dirname( __FILE__ ) ), "run_python_script.rb" )
Daemons.run( python_light_runner_file, options )
