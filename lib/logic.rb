# Module for the game's logic
module GameLogic
  # Method to ask for a guess of a letter or of the whole word
  def ask_guess
    puts "\nEnter your guess [a-z], or if you think you know the answer, you can enter the whole word!"
    puts "\nIf you want to save the game, enter 'save' or 'quit' if you want to exit without saving"
    response = ""

    # Ask for input until the answer has alphabetic characters, rejecting anything that contains a number
    loop do
      response = gets.chomp.downcase
      break if /^[a-zA-Z]+$/.match?(response)
    end

    # If the user enters the word 'save', save the current game as it is
    if response == "save"
      save_file
    elsif response == "quit"
      # If the user enters the word 'quit', exit the game without saving progress
      puts "\nSorry to see you go! Thank you for playing Hangman!"
      exit
    else
      check_guess(response)
    end
  end

  # Method to check if a letter / word is correctly guessed
  def check_guess(letter)
    # Create 2 arrays, one for the current guess and another for the secret word
    @full_guess = letter.chars
    letters = @secret_word.chars

    # If the arrays of the secret word and the current guess are equal, the player won the game, as it means each letter is correctly guessed
    if @full_guess == letters
      @new_encrypted = @full_guess
      print_board(@new_encrypted.join(""))
      @is_winner = true
    end

    # If the array that contains the letters of the secret word doesn't have any letter equal to the current guess and the arrays themselves are different, decrement the guesses by 1 and add the incorrect guesses to the list
    if !letters.any?(letter) && @full_guess != letters
      @guesses -= 1
      @incorrect_letters.push(letter)
    end
    # At the end of this check, update the display
    update_print(letters, letter)

    # If the game reaches zero guesses left, the game ends
    @game_end = true if @guesses.zero?
  end

  # Method to update the display
  def update_print(letters, letter)
    # Iterate over each of the characters of the secret word and if it is equal to the current guess (letter), update the @new_encrypted to be equal to the guess
    letters.each_with_index do |i, idx|
      if i == letter
        @new_encrypted[idx] = letter
      end
    end
    # Print the display with the new guessed letters
    print_board(@new_encrypted.join(""))

    # If the encrypted word is equal to the secret word, it means the player guessed all the letters and won the game
    if @new_encrypted.join("") == @secret_word
      @is_winner = true
    end
  end

  # Method for saving the file
  def save_file
    filename = nil
    user_filename = nil

    puts "\nEnter the name of how you want to save the file or press the 'Enter' key for a random filename generation"

    # Ask for a filename until it has letters/numbers or is an empty string in case the user presses the 'Enter' key without typing out anything
    loop do
      user_filename = gets.chomp.downcase
      break if /[[:alpha:]]+/.match?(user_filename) || user_filename == ""
    end

    # If the string is empty, choose 2 random words (that can be the same) from the list of google words and join them with an underscore symbol to create a file name
    if user_filename == ""
      names = 2.times.map { open("google-10000-english.txt").readlines.sample.strip }
      filename = names.join("_")
      # TODO add check to see if a file with that name doesn't already exist
    elsif user_filename != ""
      # If it is not an empty string, assign it to what the user wants
      filename = user_filename
      # TODO add check to see if a file with that name doesn't already exist
    end

    puts "\nYour file was saved as '#{filename}.txt'. It is located in the 'saved' folder."
    puts "Thanks for playing! Come back anytime :)"
    exit
  end

  # Method to restart the game
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