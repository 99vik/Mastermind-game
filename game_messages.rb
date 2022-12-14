# frozen_string_literal: true

# Game messages

module GameMessages
  def welcome_msg
    puts "\nHello, welcome to mastermind game!".blue.bold
  end

  def choose_gamemode_msg
    puts "\nChoose if you want to be either code breaker or code maker:".bold.blue
    puts '1 for code breaking'
    puts '2 for code making'
  end

  def choose_numbers_msg
    puts 'Choose 4 numbers from 1 to 6:'
  end

  def human_solver_choosen_msg
    puts "\nYou have choosen to be code breaker.".blue.bold
    puts 'Random code has been generated.'
  end

  def computer_solver_choosen_msg
    puts "\nYou have choosen to be code maker.".blue.bold
    puts 'Choose your code that computer will try to break!'
  end

  def choose_your_code_msg
    puts "\nChoose your secret code.".blue.bold
    puts 'Enter 4 numbers, from 1 to 6:'
  end

  def chosing_input_error_msg
    puts "\nIncorrect input. Choose 1 for code breaking or 2 for code making".red.bold
  end

  def wrong_numbers_input_msg
    puts "\nInvalid input, type 4 numbers from 1 to 6.".red.bold
  end

  def computer_win_msg
    puts "\nComputer cracked the code!".red.bold
  end

  def computer_lost_msg
    puts "\nComputer couldn't crack the code!".green.bold
  end

  def display_round_number_msg(round_number)
    puts "\nRound: #{round_number} / 12".bold
  end

  def lines_msg
    puts "\n\n____________________________________________________________"
  end

  def computer_number_generating_msg
    puts "\nComputer is generating numbers....".blue.bold
  end

  def lost_msg
    puts "\nYou lost!".red.bold
  end

  def win_msg
    puts "\nCongratulations, you cracked the code!".green.bold
  end

  def play_again_msg
    puts "\nPlay again?".bold.blue
    puts '1 to play again'
    puts '2 to exit'
  end

  def play_again_wrong_input_msg
    puts "\nIncorrect input.".bold
    puts '1 to play again'
    puts '2 to exit'
  end
end

# Modify messages for colour, boldnes etc.
class String
  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end
end
