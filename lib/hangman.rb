require "io/console"
require_relative "logic"
require_relative "display"

class Hangman
  include GameLogic
  include Display

  attr_accessor :secret_word, :is_winner, :game_end, :response, :guesses, :length, :word_encrpyted, :type_of_game

  def initialize
    @secret_word = get_word
    @length = @secret_word.length
    @is_winner = false
    @game_end = false
    @guesses = 6
    @word_encrpyted = "_" * @length
    @new_encrypted = Array.new(@secret_word.length, "_")
    @incorrect_letters = []
    @type_of_game = ""

    Intro.new
    choose_type

    # New game
    if @type_of_game == "1"
      print_board(word_encrpyted)
      loop do
        ask_guess
        break if @is_winner || @game_end
      end
    elsif @type_of_game == "2"
      # Load game
      puts "loading!"
    end

    if @is_winner
      puts "Congrats! You guessed the code!"
    elsif @game_end && !@is_winner
      puts "You lost! The word was '#{@secret_word}'"
      puts "Better luck next time!"
    end
    delete
    restart
  end

  def get_word
    word = ""
    until (5..12).cover?(word.length)
      word = open("google-10000-english.txt").readlines.sample.strip
    end
    word
  end

  def choose_type
    loop do
      @type_of_game = gets.chomp

      break if @type_of_game == "1" || @type_of_game == "2"
    end
  end

  def delete
    @secret_word = nil
    @is_winner = nil
    @game_end = nil
    @length = nil
    @guesses = nil
    @word_encrpyted = nil
  end
end
