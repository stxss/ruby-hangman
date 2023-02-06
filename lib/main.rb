class Hangman

    def initialize
        @secret_word = get_word
        puts "the selected was '#{@secret_word}' and its length is #{@secret_word.length}"
    end

    def get_word
        word = ""
        until (5..12).cover?(word.length)
           word = open("google-10000-english.txt").readlines.sample.strip
        end
        word
    end
end




Hangman.new
