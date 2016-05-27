#! /usr/bin/ruby

require './unicode.rb'
require 'pp'


## ---  dump the Table
#
# @cpt = Marshal.load( File.open("unicode.marshal") )
# pp @cpt
#

## --- Check Wether basic methods work
#
Unicode::CodePointTable.load_state
t = Unicode::Character.new('0')
pp t

puts "number: #{t.is_number?.to_s}, alpha: #{t.is_letter?.to_s}"


