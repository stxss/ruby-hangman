require "io/console"
require_relative "logic"
require_relative "display"
require_relative "text_styles"

class Hangman
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

    Intro.new
    choose_type

    if @type_of_game == "1"
      print_board(word_encrypted)

      loop do
        ask_guess
        break if @is_winner || @game_end
      end
    elsif @type_of_game == "2"
      puts "Select the number corresponding to the file to load the game from:\n\n"

      Dir.each_child("saved").each_with_index do |i, idx|
        puts "#{"[#{idx + 1}]".bold.fg_color(:light_blue)} #{i}"
      end

      filecount = Dir[File.join("saved", "**", "*")].count { |file| File.file?(file) }

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

    if @is_winner
      puts "Congrats! You guessed the code!"
    elsif @game_end && !@is_winner
      puts "You lost! The word was '#{@secret_word}'"
      puts "Better luck next time!"
    end
    delete
    restart
  end

  def choose_type
    loop do
      @type_of_game = gets.chomp

      break if @type_of_game == "1" || @type_of_game == "2"
    end
  end

  def get_word
    word = ""
    until (5..12).cover?(word.length)
      word = open("google-10000-english.txt").readlines.sample.strip
    end
    word
  end

  def delete
    @secret_word = nil
    @is_winner = nil
    @game_end = nil
    @length = nil
    @guesses = nil
    @word_encrypted = nil
  end
end
