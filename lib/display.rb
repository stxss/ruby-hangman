class Display
  attr_reader :word, :length
  attr_accessor :guesses, :word_encrpyted

  def initialize(word)
    @word = word
    @length = word.length
    @guesses = 6
    @word_encrpyted = "_" * @length
    print_board
  end

  def print_board
    system("clear")
    puts "                      |            "
    puts "                      | #{guesses} Guesses Left  "
    puts "   #{word_encrpyted}                   +____________________"
    puts "                                   "
    puts "                                   "
    puts "                                   "
    puts "                                   "
  end
end
