# frozen_string_literal: true

require_relative 'human_solver'
require_relative 'computer_solver'

class Display
  private

  @code = []

  def get_code(code)
    @code = code
  end

  public

  def get_code_temp(code)
    get_code(code)
    nil
  end

  def initialize
    @round_number = 1
    @round_values = {}
    (1..12).to_a.each { |i| @round_values[i] = Array.new(4) }
    reset_clues
  end

  def reset_clues
    @clues = {}
    (1..12).to_a.each do |i| @clues[i] = {
      red: 0,
      white: 0
    } 
    end
  end

  def add_choosen_to_rounds(choosen_input, round_number)
    @round_number = round_number
    @round_values[round_number] = choosen_input
  end

  def get_last_input(round_number)
    @round_values[round_number - 1]
  end

  def display_board
    generate_board
    puts @board
  end

  def generate_board
    reset_clues
    @board = ''
    @round_values.reverse_each do |i|
      @current_row = i[0]
      generate_row_round_num(i[0])
      generate_row(i[1])
    end
  end

  def generate_row_round_num(round_number)
    @board += if round_number < 10
                "\n #{round_number}   | "
              else
                "\n #{round_number}  | "
              end
  end


  def generate_row(array_input)
    array_input.each do |i|
      if i.nil?
        @board += '    '
      else
        colorize_input_number(i)
      end
    end
    @board += '|    Clues: '
    @board += generate_clues(array_input)
  end
  

  def generate_clues(array_input)
    @red_clues = ''
    @white_clues = ''
    generate_clue(array_input)
    @red_clues + @white_clues
  end

  def get_clues
    @clues
  end

  def generate_clue(array_input)
    @temp_code = @code.dup
    @temp_array_input = array_input.dup
    @temp_code.each_index do |index|
      number_at_right_place?(index)
    end
    @temp_code.each_index do |index|
      number_in_code?(index)
    end 
  end

  def number_at_right_place?(index)
    if @temp_code[index] == @temp_array_input[index]
      @temp_code[index] = nil
      @temp_array_input[index] = nil
      @red_clues += "\e[31m\u25CF\e[0m "
      @clues[@current_row][:red] += 1
    end
  end

  def number_in_code?(index)
    if @temp_array_input[index].nil?
      false
    elsif @temp_code.any?(@temp_array_input[index])
      @temp_code[@temp_code.find_index(@temp_array_input[index])] = nil
      @temp_array_input[index] = nil
      @white_clues += "\e[39m\u25CF\e[0m "
      @clues[@current_row][:white] += 1
    end
  end

  def colorize_input_number(number)
    case number
    when 1
      @board += "\e[41m \e[30m1 \e[0m "
    when 2
      @board += "\e[42m \e[30m2 \e[0m "
    when 3
      @board += "\e[44m \e[30m3 \e[0m "
    when 4
      @board += "\e[46m \e[30m4 \e[0m "
    when 5
      @board += "\e[103m \e[30m5 \e[0m "
    when 6
      @board += "\e[107m \e[30m6 \e[0m "
    end
  end
end
