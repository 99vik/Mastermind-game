# frozen_string_literal: true

require_relative 'game_messages'
require_relative 'display'
include GameMessages

class CodeBreaking
  private

  @rounds = (1..12).to_a
  @code = []

  def generate_random_code
    code = []
    (1..4).each do |_i|
      code.push(rand(1..6))
    end
    code
  end

  public

  def initialize
    @display = Display.new
    @round_number = 1
    human_solver_choosen_msg
    @code = generate_random_code
    @display.get_code_temp(@code)
  end

  def start
    play_round until check_for_win? || (@round_number > 12)
    if check_for_win?
      puts win_msg
    else
      lost_msg
    end
  end

  def play_again?
    play_again_msg
    play_again_choosing
  end

  def play_again_choosing
    case gets.strip.to_i
    when 1
      true
    when 2
      false
    else
      play_again_wrong_input_msg
      play_again_choosing
    end
  end

  def play_round
    display_round_number_msg(@round_number)
    choose_numbers
    @display.display_board
    @round_number += 1
  end

  def choose_numbers
    choose_numbers_msg
    choosen_numbers = gets.strip.delete(' ').split('').map(&:to_i)
    until check_if_input_valid?(choosen_numbers)
      wrong_numbers_input_msg
      choosen_numbers = gets.strip.delete(' ').split('').map(&:to_i)
    end
    @display.add_choosen_to_rounds(choosen_numbers, @round_number)
  end

  def check_if_input_valid?(input)
    return true if input.length == 4 && input.all? { |i| (1..6).to_a.include?(i) }

    false
  end

  def check_for_win?
    @code == @display.get_last_input(@round_number)
  end
end
