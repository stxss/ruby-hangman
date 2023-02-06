require "io/console"

class Hangman
  def initialize
    @secret_word = get_word
    puts "the selected was '#{@secret_word}' and its length is #{@secret_word.length}"
    Intro.new
    press_to_continue
    Display.new(@secret_word)
  end

  def get_word
    word = ""
    until (5..12).cover?(word.length)
      word = open("google-10000-english.txt").readlines.sample.strip
    end
    word
  end

  def press_to_continue
    puts "Press any key to start the game"
    $stdin.getch
    print "            \r"
  end
end
