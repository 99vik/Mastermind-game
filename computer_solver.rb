# frozen_string_literal: true

require_relative 'game_messages'
require_relative 'display'
include GameMessages

class CodeMaking
  # (s)
  @rounds = (1..12).to_a
  @code = []

  def initialize
    # (s)
    set_starting_variables
    computer_solver_choosen_msg
    enter_code
    @display.get_code_temp(@code)
  end

  def set_starting_variables
    @display = Display.new
    @round_number = 1
    @tried_codes = []
    @times_in_code = {}
    @positions = {}
    (1..6).to_a.each { |i| @times_in_code[i] = nil }
    (1..4).to_a.each { |i| @positions[i] = Array.new(4) }
    @code_guess = {
      times_in_code: @times_in_code,
      clues: @display.get_clues,
      positions: @positions
    }
  end

  # (s) - same as human breaker
  def start
    play_round until check_for_win? || (@round_number > 12)
    if check_for_win?
      puts computer_win_msg
    else
      computer_lost_msg
    end
  end

  # (s)
  def play_again?
    play_again_msg
    play_again_choosing
  end

  # (s)
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

  # (s)
  def check_for_win?
    @code == @display.get_last_input(@round_number)
  end

  def enter_code
    choose_your_code_msg
    choose_code = gets.strip.delete(' ').split('').map(&:to_i)
    until check_if_input_valid?(choose_code)
      wrong_numbers_input_msg
      choose_code = gets.strip.delete(' ').split('').map(&:to_i)
    end
    @code = choose_code
  end

  # (s)
  def check_if_input_valid?(input)
    return true if input.length == 4 && input.all? { |i| (1..6).to_a.include?(i) }

    false
  end

  def play_round
    lines_msg
    display_round_number_msg(@round_number)
    puts "\nCode: #{@code}"
    computer_generate_numbers
    @display.display_board
    @code_guess[:clues] = @display.get_clues
    check_for_clues
    check_positions
    @round_number += 1
  end

  def computer_generate_numbers
    computer_number_generating_msg
    sleep(0.8)
    @display.add_choosen_to_rounds(generate_guess, @round_number)
  end

  def generate_guess
    if @round_number == 1
      starting_guess
    elsif !has_all_numbers?
      increment_guess
    end
    create_guess_array
  end

  def increment_guess
    if @current_guessing_number == 6
      @current_guessing_number = 1
    else
      @current_guessing_number += 1
    end
  end

  def starting_guess
    random_num = rand(1..6)
    @current_guessing_number = random_num.dup
  end

  def create_guess_array
    @guess_array = []

    @code_guess[:positions].each do |i|
      @guess_array[i[0] - 1] = pick_a_number_from_positions(i[1])
    end
    if @tried_codes.include?(@guess_array) || guess_array_doesnt_include_all_nums?
      create_guess_array
    else
      @tried_codes.push(@guess_array)
      return @guess_array
    end
  end

  def guess_array_doesnt_include_all_nums?
    !get_array_with_included_numbers.all? { |i| @guess_array.include?(i) }
  end

  def pick_a_number_from_positions(input_array)
    temp_array = input_array.compact

    loop do
      array_random_num = temp_array.sample
      if temp_array.length.zero?
        return @current_guessing_number
      elsif @guess_array.count(array_random_num) < @code_guess[:times_in_code][array_random_num]
        return array_random_num
      else
        temp_array.delete_at(temp_array.index(array_random_num))
      end
    end
  end

  def push_numbers_on_array(times_in_code)
    if !times_in_code[1].nil?
      times_in_code[1].times do
        @guess_array.push(times_in_code[0])
      end
    end
  end

  def check_for_clues
    if @round_number == 1
      if @code_guess[:clues][1][:red] != 0
        @code_guess[:times_in_code][@current_guessing_number] = @code_guess[:clues][1][:red]
      else
        @code_guess[:times_in_code][@current_guessing_number] = 0
      end
    elsif @round_number >= 2 && !has_all_numbers?
      if !new_clue_spotted?
        @code_guess[:times_in_code][@current_guessing_number] = 0
      else
        @code_guess[:times_in_code][@current_guessing_number] = number_of_new_clues
      end
    end
  end

  def new_clue_spotted?
    number_of_new_clues != 0
  end

  def number_of_new_clues
    (number_of_white_clues_this_round + number_of_red_clues_this_round) - (number_of_red_clues_last_round + number_of_white_clues_last_round)
  end

  def number_of_red_clues_this_round
    @code_guess[:clues][@round_number][:red]
  end

  def number_of_white_clues_this_round
    @code_guess[:clues][@round_number][:white]
  end

  def number_of_red_clues_last_round
    @code_guess[:clues][@round_number - 1][:red]
  end

  def number_of_white_clues_last_round
    @code_guess[:clues][@round_number - 1][:white]
  end

  def has_all_numbers?
    number_of_red_clues_last_round + number_of_white_clues_last_round == 4
  end

  def check_positions
    if @round_number == 1
      if (number_of_red_clues_this_round + number_of_white_clues_this_round) > 0
        push_number_on_positions
      end
    elsif new_clue_spotted?
        push_number_on_positions
    end
    check_for_positions_logic
  end

  def check_for_positions_logic
    if @round_number == 1
      return
    else
      if only_white_clues?
        if two_white_clues_one_old_white_clues?
          @code_guess[:positions][get_position_of_number] = [@current_guessing_number]
          delete_in_others(@current_guessing_number)
        elsif two_white_clues_one_old_red_clue?
          @code_guess[:positions][get_position_of_number] = [@current_guessing_number]
          delete_in_others(@current_guessing_number)
        else
          delete_in_positions
        end
      elsif only_red_clues?
        put_number_as_only_in_position
      elsif one_new_red_clues_with_old_one_white_clue?
        @code_guess[:positions][get_position_of_number].delete(@current_guessing_number)
        @code_guess[:positions][get_position_of_number].delete(@guess_array[@guess_array.index { |i| i != @current_guessing_number }])
      elsif one_red_one_white_and_old_red?
        @code_guess[:positions][get_position_of_number].delete(@guess_array[@guess_array.index { |i| i != @current_guessing_number }])
        @code_guess[:positions][get_position_of_number].delete(@current_guessing_number)
      end
    end
  end

  def two_white_clues_one_old_red_clue?
    number_of_red_clues_last_round == 1 && number_of_white_clues_last_round == 0 && number_of_red_clues_this_round == 0 && number_of_white_clues_this_round == 2
  end

  def one_red_one_white_and_old_red?
    number_of_red_clues_last_round == 1 && number_of_white_clues_last_round == 0 && number_of_red_clues_this_round == 1 && number_of_white_clues_this_round == 1
  end

  def two_white_clues_one_old_white_clues?
    number_of_white_clues_last_round == 1 && number_of_red_clues_last_round == 0 && number_of_white_clues_this_round == 2 && number_of_red_clues_this_round == 0
  end

  def get_position_of_number
    @guess_array.index { |i| i != @current_guessing_number } + 1
  end

  def one_new_red_clues_with_old_one_white_clue?
    number_of_red_clues_last_round == 0 && number_of_white_clues_last_round == 1 && number_of_red_clues_this_round == 1 && number_of_white_clues_this_round == 1
  end

  def put_number_as_only_in_position
    get_array_with_included_numbers.each do |i|
      if @code_guess[:times_in_code][i] == @guess_array.count(i)
        get_indexes_of_num_in_guess_array(i).each do |j|
          @code_guess[:positions][j + 1] = [i]
          delete_in_others(i)
        end
      end
    end
  end

  def delete_in_others(number)
    @code_guess[:positions].each do |i|
      if i[1].length > 1
        i[1].delete(number)
      end
    end
  end

  def get_indexes_of_num_in_guess_array(number)
    @guess_array.each_index.select{ |index| @guess_array[index] == number }
  end

  def only_red_clues?
    number_of_white_clues_this_round == 0 && number_of_red_clues_this_round != 0
  end

  def delete_in_positions
    @guess_array.each_index do |i|
      @code_guess[:positions][i + 1].delete(@guess_array[i])
    end
  end

  def only_white_clues?
    number_of_red_clues_this_round == 0 && number_of_white_clues_this_round != 0
  end

  def get_array_with_number_indexes_in_guess_array
    array = []
    get_array_with_included_numbers.each do |i| 
      array.push(@guess_array.each_index.select{|j| @guess_array[j] == i} )
    end
    array.flatten!
  end

  def get_array_with_included_numbers
    @array_with_included_numbers = []
    @code_guess[:times_in_code].each do |i|
      if i[1] != nil && i[1] != 0
        @array_with_included_numbers.push(i[0])
      end
    end
    @array_with_included_numbers
  end

  def push_number_on_positions
      @code_guess[:times_in_code][@current_guessing_number].times { remove_nil_on_positions }
  end

  def remove_nil_on_positions
    @code_guess[:positions].each do |i|
      if i[1].any?(nil)
        i[1].shift
        i[1].push(@current_guessing_number)
      end
    end
  end
end
