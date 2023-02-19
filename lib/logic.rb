require "io/console"
require "yaml"

module GameLogic
  def ask_guess
    puts "\nEnter your guess [a-z], or if you think you know the answer, you can enter the whole word!"
    puts "\nIf you want to save the game, enter 'save' or 'quit' if you want to exit without saving"
    response = ""

    loop do
      response = gets.chomp.downcase
      break if /^[a-zA-Z]+$/.match?(response) && !@incorrect_letters.any?(response)
    end

    if response == "save"
      save_file
    elsif response == "quit"
      puts "\nSorry to see you go! Thank you for playing Hangman!"
      exit
    else
      check_guess(response)
    end
  end

  def check_guess(letter)
    @full_guess = letter.chars
    letters = @secret_word.chars

    if @full_guess == letters
      @new_encrypted = @full_guess
      @new_encrypted.to_s
      print_board(@new_encrypted)
      @is_winner = true
    end

    if !letters.any?(letter) && @full_guess != letters
      @guesses -= 1
      @incorrect_letters.push(letter)
    end
    update_print(letters, letter)

    @game_end = true if @guesses.zero?
  end

  def update_print(letters, letter)
    letters.each_with_index do |i, idx|
      if i == letter
        @new_encrypted[idx] = letter
      end
    end

    to_print = @new_encrypted.join("")
    print_board(to_print)

    if to_print == @secret_word
      @is_winner = true
    end
  end

  def save_file
    filename = nil
    user_filename = nil

    puts "\nEnter the name of how you want to save the file or press the 'Enter' key for a random filename generation"

    loop do
      user_filename = gets.chomp.downcase

      if /^[a-zA-Z]+$/.match?(user_filename) || user_filename == ""
        if File.file?("saved/#{user_filename}.yaml")
          puts "\nA file with that name already exists. Please enter another name:"
          next
        end
        break
      end
    end

    if user_filename == ""
      names = 2.times.map { open("google-10000-english.txt").readlines.sample.strip }
      if !File.file?("saved/#{names.join("_")}.yaml")
        filename = names.join("_")
      end
    elsif user_filename != ""
      filename = user_filename
    end

    to_save = open("saved/#{filename}.yaml", "w")
    to_save.puts(to_yaml)
    to_save.close

    puts "\nYour file was saved as '#{filename}.yaml'. It is located in the 'saved' folder."
    puts "Thanks for playing! Come back anytime :)"
    exit
  end

  def to_yaml
    YAML.dump(self)
  end

  def load_game(path)
    file = YAML.safe_load(File.read(path), permitted_classes: [Hangman])

    @secret_word = file.secret_word
    @guesses = file.guesses
    @new_encrypted = file.new_encrypted
    @incorrect_letters = file.incorrect_letters
    @full_guess = file.full_guess

    print_board(new_encrypted.join(""))
    loop do
      ask_guess
      break if @is_winner || @game_end
    end
  end

  def restart
    loop do
      puts "\nDo you want to play again? Please enter a valid option. [Y/N]"
      answer = gets.chomp
      case answer
      when "Y", "y", "yes".downcase
        Hangman.new
      when "N", "n", "no".downcase
        puts "Thank you for playing Hangman!"
        exit
      end
    end
  end
end
