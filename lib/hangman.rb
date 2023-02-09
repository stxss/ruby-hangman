require "io/console"
require_relative "logic"
require_relative "display"
require_relative "text_styles"

# Class to initiate the game
class Hangman
  # Include the modules for the game logic and the display
  include GameLogic
  include Display
  using TextStyles

  attr_accessor :secret_word, :is_winner, :game_end, :response, :guesses, :length, :word_encrypted, :new_encrypted, :full_guess,
    :type_of_game, :incorrect_letters

  def initialize
    @secret_word = get_word
    @length = @secret_word.length
    @is_winner = false
    @game_end = false
    @guesses = 6
    @word_encrypted = "_" * @length
    @new_encrypted = Array.new(@secret_word.length, "_")
    @incorrect_letters = []
    @type_of_game = ""

    # Print the introduction and prompt to choose if the player wants to start a new game or load an already saved game
    Intro.new
    choose_type

    # If the type is 1, create a new game
    if @type_of_game == "1"
      # Set up the first board
      print_board(word_encrypted)

      # Ask for guesses until the user wins or is out of guesses
      loop do
        ask_guess
        break if @is_winner || @game_end
      end
    elsif @type_of_game == "2"
      # If it's 2, load a saved game
      puts "Select the number corresponding to the file to load the game from:\n\n"

      # Iterate over each file that's saved and display it on screen
      Dir.each_child("saved").each_with_index do |i, idx|
        puts "#{"[#{idx + 1}]".bold.fg_color(:light_blue)} #{i}"
      end

      # Count the number of files in the saved folder
      filecount = Dir[File.join("saved", "**", "*")].count { |file| File.file?(file) }

      # Ask for a valid input until the user's answer is one of the saved files
      @chosen_file = ""
      all_files = Dir.entries("saved").select { |f| !File.directory? f }

      loop do
        @chosen_file = gets.chomp.to_i
        break if @chosen_file.between?(1, filecount)
      end

      selected_file = all_files[@chosen_file - 1]
      path = "saved/#{selected_file}"

      puts "saved/#{selected_file}"
      load_game(path)
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
    @word_encrypted = nil
  end
end
