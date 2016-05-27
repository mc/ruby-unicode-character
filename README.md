a simple library that gives access to unicode properties of a character.

scripts contained:
 - examples/transform.rb

    reads a unicode standards file retrieved from 
    http://www.unicode.org/reports/tr44/tr44-16.html#UnicodeData.txt and 
    builds up a Table containing all codepoints (i.e. valid characters
    in Unicode) and their properties.  It marshals the codepointable and
    stores it in a file called unicode.marshal





- load Unicode Data from the marshaled File:
  Unicode::CodePointTable.load_state
  This will load the marshaled data into the codetable. Since the class
  is a singleton class, you only need to do it once and you dont need
  to save the state yourself. However you need to do call #load_state once
  if you want to have a usable Codepoint Table.

- add codepoints to the table
  Unicode::CodePointTable.add(unicode_codepoint)
  codepoint is an instance of class Unicode::Codepoint; you will need to
  set the properties manually.  although if you need an update, you can
  just download the official UnicodeData.txt and run transform.rb on it.

- dump codepointtable to marshal file
  Unicode::CodePointTable.dump_state
  you probably dont need to do that either, this saves the state to the
  marshal file.

- load complete unicode properties for a specific character
  Unicode::Character.new(character)
  pass in a single character and this method will return the respective
  Unicode::CodePoint Object. inspect the object if you want to know more.

- Unicode::Character Instances will provide some convinience methods if
  you want to just ask basic questions, like #is_letter? will tell you
  wether the codepoint is a category 'Letter'. this is done by deferring
  methods which are not inside the Character class to the Codepoint class.

- for basic information you should use the more efficient way of doing
  Unicode::CodePointTable.char_category(character)


Unicode::Character.new(character)
 -> returns a Unicode::Codepoint object for the specific character

Unicode::CodePointTable.load_state
 -> will load the table

Unicode::CodePointTable.add(Unicode::Codepoint)
 -> will add a codepoint to the table

Unicode::CodePointTable.dump_state
 -> will save the state

Unicode::CodePointTable.find(numerical_value_of_character)
 -> will return the codepoint for the numerical value of a character 
    (e.g. 'A' -> 65; you can use String#ord() to retrieve
    that value).

Unicode::CodePointTable.char_category(char)
 -> will retrieve the general category for the character passed in,
    i.e. :letter for 'A'
    use this shortcut if you just need the category of a character.
    it is more efficient since it doesnt need to generate a new 
    instance of ::Character

Unicode::CodePoint#is_letter?
 -> answers true for a letter, false for everything else

Unicode::CodePoint#is_number?
 -> answers true for a numeric codepoint, false for everything else

Unicode::Codepoint#general_category
 -> will return the general_category for a codepoint, i.e. :letter
    for 'A'




pull requests welcome.
