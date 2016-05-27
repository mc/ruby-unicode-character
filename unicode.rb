require 'singleton'

module Unicode
    module Utility
        class BidiClasses
            @bidi_classes = {
                 'L' =>    :left_to_right,
                 'R' =>    :right_to_left,
                 'AL' =>   :arabic_letter,
                 'EN' =>   :european_number,
                 'ES' =>   :european_separator,
                 'ET' =>   :european_terminator,
                 'AN' =>   :arabic_number,
                 'CS' =>   :common_separator,
                 'NSM' =>  :nonspacing_mark,
                 'BN' =>   :boundary_neutral,
                 'B' =>    :paragraph_separator,
                 'S' =>    :segment_separator,
                 'WS' =>   :whitespace,
                 'ON' =>   :other_neutral,
                 'LRE' =>  :left_to_right_embedding,
                 'LRO' =>  :left_to_right_override,
                 'RLE' =>  :right_to_left_embedding,
                 'RLO' =>  :right_to_left_override,
                 'PDF' =>  :pop_directional_format,
                 'LRI' =>  :left_to_right_isolate,
                 'RLI' =>  :right_to_left_isolate,
                 'FSI' =>  :first_strong_isolate,
                 'PDI' =>  :pop_directional_isolate }

            def self.lookup(key)
                return @bidi_classes[key]
            end
        end

        class Categories
            @categories = {
                 'Lu' =>   :uppercase_letter,
                 'Ll' =>   :lowercase_letter,
                 'Lt' =>   :titlecase_letter,
                 'LC' =>   :cased_letter,       # supercategory Lu|Ll|Lt
                 'Lm' =>   :modified_letter,
                 'Lo' =>   :other_letter,
                 'L' =>    :letter,             # supercategory L|Lo|Lm
                 'Mn' =>   :nonspacing_mark,
                 'Mc' =>   :spacing_mark,
                 'Me' =>   :enclosing_mark,
                 'M' =>    :mark,               #  Mark    Mn | Mc | Me
                 'Nd' =>   :decimal_number,
                 'Nl' =>   :letter_number,
                 'No' =>   :other_number,
                 'N' =>    :number,             #   Number  Nd | Nl | No
                 'Pc' =>   :connector_punctuation,
                 'Pd' =>   :dash_punctuation,
                 'Ps' =>   :open_punctuation,
                 'Pe' =>   :close_punctuation,
                 'Pi' =>   :initial_punctuation,
                 'Pf' =>   :final_punctuation,
                 'Po' =>   :other_punctuation,
                 'P' =>    :punctuation,        #Pc | Pd | Ps | Pe | Pi | Pf | Po
                 'Sm' =>   :math_symbol,
                 'Sc' =>   :currency_symbol,
                 'Sk' =>   :modifier_symbol,
                 'So' =>   :other_symbol,
                 'S' =>    :symbol,             # Sm | Sc | Sk | So
                 'Zs' =>   :space_separator,
                 'Zl' =>   :line_separator,
                 'Zp' =>   :paragraph_separator,
                 'Z' =>    :separator,          #   Separator   Zs | Zl | Zp
                 'Cc' =>   :control,
                 'Cf' =>   :format,
                 'Cs' =>   :surrogate,
                 'Co' =>   :private_use,
                 'Cn' =>   :unassigned,
                 'C' =>    :other          #   Other   Cc | Cf | Cs | Co | Cn
            }

            def self.lookup(key)
                return @categories[key]
            end
        end
    end

    class CodePoint
        attr_reader :byte, :bidi_class, :category, :combining_class, :lowercase_variant, :uppercase_variant, :titlecase_variant
        attr_accessor :iso_comment, :name, :un1, :decomposition, :numeric_value, :bidi_mirrored

        def byte=(byte)
            if byte.is_a? Integer
                @byte = byte
            elsif byte.is_a? String
                @byte = byte.to_i(16)
            end
        end

        def bidi_class=(bidiclass)
            @bidi_class = Unicode::Utility::Categories.lookup(bidiclass)
            raise StandardError, "Unknown bidiclass #{bidiclass}" if @bidi_class.nil?
        end

        def category=(category)
            @category = @categories[category]
            raise StandardError, "Unknown character category: #{category}" if @category.nil?
        end

        def combining_class=(cclass)
            @combining_class = cclass.to_i
        end

        def lowercase_variant=(variant)
            @lowercase_variant = variant.to_i(16)
        end
        
        def uppercase_variant=(variant)
            @uppercase_variant = variant.to_i(16)
        end

        def titlecase_variant=(variant)
            @titlecase_variant = variant.to_i(16)
        end
# --
        def is_letter?
            [:uppercase_letter, :lowercase_letter, :titlecase_letter, :cased_letter, :modified_letter, :other_letter, :letter].include? category
        end

        def is_number?
            [:decimal_number, :letter_number, :other_number, :number].include? category
        end

        def general_category
            if    [:uppercase_letter, :lowercase_letter, :titlecase_letter, :cased_letter, :modified_letter, :other_letter, :letter].include? category
                return :letter
            elsif [:decimal_number, :letter_number, :other_number, :number].include? category
                return :digit
            elsif [:nonspacing_mark, :spacing_mark, :enclosing_mark].include? category
                return :mark
            elsif [:connector_punctuation, :dash_punctuation, :open_punctuation, :close_punctuation, :initial_punctuation, :final_punctuation, :other_punctuation, :punctuation].include? category
                return category # :punctuation
            else
                return category
            end
        end
# -- 
    end

    class CodePointTable
        include Singleton
        
        attr_accessor :codepoints

        class << self
            def add(cp)
                @codepoints ||= Hash.new

                if cp.is_a? CodePoint
                    @codepoints[cp.byte] = cp
                else
                    raise StandardError, "Value is not a Codepoint"
                end
            end
        end

        def self.dump_state
            File.open("unicode.marshal", "w+") do |fh|
                fh.write(Marshal.dump(@codepoints))
            end
        end

        def self.load_state
            @codepoints = Marshal.load( File.open("unicode.marshal") )
        end

        def self.find(nv)
            return @codepoints[nv]
        end
        
        def self.char_category(char)
            return @codepoints[char.ord].general_category
        end
    end

    class Character
        def initialize(char)
            if char.is_a? String
                @character = char
                @nv        = char.ord
                @cp        = CodePointTable.find(@nv)
            else
                raise StandardError, "Char #{char.class.to_s} must be String"
            end
        end
        
        def method_missing(funcname)
            if @cp.respond_to? funcname
                @cp.send funcname
            else
                raise NoMethodError.
                    new("undefined method '#{funcname}' for #{self.class}")
            end
        end

    end
end

