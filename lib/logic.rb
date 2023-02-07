module GameLogic
  def ask_guess
    puts "Enter your guess [a-z]"
    puts "If you want to save the game, enter 'save' or 'quit' if you want to exit without saving"
    response = ""
    loop do
      response = gets.chomp.downcase
      break if /[[:alpha:]]+/.match?(response)
    end
    if response == "save"
        puts "save"
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
      print_board(@new_encrypted.join(""))
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
    print_board(@new_encrypted.join(""))

    if @new_encrypted.join("") == @secret_word
      @is_winner = true
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
