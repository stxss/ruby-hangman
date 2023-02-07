module Display
  def print_board(to_print)
    system("clear")
    puts "     +----------------+                          "
    puts "     | #{@guesses} Guesses Left | "
    puts "     +----------------+"
    puts "                                   "
    puts "          #{to_print}           "
    puts "                                   "
    puts "                                   "
    puts "Incorrect letters : #{@incorrect_letters.join(" ")}  "
    puts "                                   "
  end
end
