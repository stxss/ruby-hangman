module GameLogic
  def ask_guess
    puts "Enter your guess [a-z]"
    response = ""
    loop do
      response = gets.chomp.downcase
      break if /[[:alpha:]]+/.match?(response)
    end
    check_guess(response)
  end

  def check_guess(letter)
    @full_guess = letter.chars
    letters = @secret_word.chars

    if @full_guess == letters
      @new_encrypted = @full_guess
      print_board(@new_encrypted.join(""))
      @is_winner = true
    end
    @guesses -= 1 if !letters.any?(letter) && @full_guess != letters
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
    puts "#{letter.length}"
    puts "#{@secret_word}"
    puts "#{@full_guess}"
    puts "#{letters}"
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
