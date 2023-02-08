require "io/console"
require_relative "logic"
require_relative "display"

# Class to initiate the game
class Hangman
  # Include the modules for the game logic and the display
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

    # Print the introduction and prompt to choose if the player wants to start a new game or load an already saved game
    Intro.new
    choose_type

    # If the type is 1, create a new game
    if @type_of_game == "1"
      # Set up the first board
      print_board(word_encrpyted)

      # Ask for guesses until the user wins or is out of guesses
      loop do
        ask_guess
        break if @is_winner || @game_end
      end
    elsif @type_of_game == "2"
      # If it's 2, load a saved game
      puts "loading!"
    end

    # If the user wins, print a congratulatory message
    if @is_winner
      puts "Congrats! You guessed the code!"
    elsif @game_end && !@is_winner
      # If the user hasn't won yet and is out of guesses, it means they lost, so print out an encouraging message
      puts "You lost! The word was '#{@secret_word}'"
      puts "Better luck next time!"
    end
    # Reset the current instance of the game and prompt for a restart of the game
    delete
    restart
  end

  # Method to choose the type of game
  def choose_type
    loop do
      @type_of_game = gets.chomp

      break if @type_of_game == "1" || @type_of_game == "2"
    end
  end

  # Method to get the random secret word from the list
  def get_word
    word = ""
    # The word has to have at least 5 letters and no more than 12
    until (5..12).cover?(word.length)
      word = open("google-10000-english.txt").readlines.sample.strip
    end
    word
  end

  # Method to delete/reset the current variables, effectively resetting the class
  def delete
    @secret_word = nil
    @is_winner = nil
    @game_end = nil
    @length = nil
    @guesses = nil
    @word_encrpyted = nil
  end
end
