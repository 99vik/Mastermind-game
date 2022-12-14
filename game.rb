# frozen_string_literal: true

require_relative 'game_messages'
require_relative 'human_solver'
require_relative 'computer_solver'
include GameMessages

class Game
  def initialize
    welcome_msg
    choose_gamemode_msg
    choose_gamemode(gets.strip)
    start_game
  end

  def start_game
    @gamemode.start
    game_finished
  end

  def game_finished
    return unless @gamemode.play_again?

    Game.new
  end

  def choose_gamemode(gamemode)
    case gamemode
    when '1'
      @gamemode = CodeBreaking.new
    when '2'
      @gamemode = CodeMaking.new
    else
      chosing_input_error_msg
      choose_gamemode(gets.strip)
    end
  end
end
