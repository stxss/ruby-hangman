require_relative "text_styles"

class Intro
  using TextStyles
  def initialize
    print_info
  end

  def print_info
    puts <<~HEREDOC
      #{"Welcome to Hangman!".bold.italic.underlined}

      This is a game where you have to guess your opponent's secret word within a limited number of turns.

      If the guessing player suggests a letter which occurs in the word, that letter is written in all its correct positions.

      If the suggested letter does not occur in the word, a tally mark is added until it completes a stick figure.

      Generally, the game ends once the word is guessed, or if all guesses have been used.

      The player guessing the word may, at any time, attempt to guess the whole word.

      If the word is correct, the game is over and the guesser wins.

    HEREDOC
  end
end
