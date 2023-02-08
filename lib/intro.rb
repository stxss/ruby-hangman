require_relative "text_styles"

# Class for the introduction
class Intro
  using TextStyles
  def initialize
    print_info
  end

  def print_info
    puts <<~HEREDOC
      #{"Welcome to Hangman!".bold.italic.underlined}

      This is a game where you have to guess your opponent's #{"secret word".underlined} within a #{"limited number of turns".underlined}.

      If the guessing player suggests a letter which #{"occurs".bold.italic.underlined} in the word, that letter is written in all its correct positions.

      If the suggested letter #{"does not occur".bold.italic.underlined} in the word, your guesses are decremented by 1 point.

      Generally, the game ends once the word is guessed, or if all guesses have been used.

      The player guessing the word may, at any time, attempt to guess the whole word.

      If the word is correct, the game is over and the guesser wins.

      Select the option that you would like to play:

      #{"[1]".bold.fg_color(:pink)} Play a new game
      #{"[2]".bold.fg_color(:pink)} Load an existing game

    HEREDOC
  end
end
