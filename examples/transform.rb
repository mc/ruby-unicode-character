#! /usr/bin/ruby

# UnicodeData.TXT - http://www.unicode.org/reports/tr44/tr44-16.html#UnicodeData.txt

require './unicode.rb'

require 'pp'


# @codepoints = Unicode::CodePointTable.new

fh = File.open("UnicodeData.txt", "r")
unicode = fh.read
fh.close

unicode.each_line do |line|
    entry = line.split(";")
    c = Unicode::CodePoint.new
    c.byte               = entry[0]
    c.name               = entry[1]
    c.category           = entry[2]
    c.combining_class    = entry[3]
    c.bidi_class         = entry[4]
    c.decomposition      = entry[5]
    c.numeric_value      = entry[6]
    c.bidi_mirrored      = entry[7]
    c.un1                = entry[8]
    c.iso_comment        = entry[9]
    c.uppercase_variant  = entry[10]
    c.lowercase_variant  = entry[11]
    c.titlecase_variant  = entry[12]

   # @codepoints.add(c)
    Unicode::CodePointTable.add(c)
end

Unicode::CodePointTable.dump_state
