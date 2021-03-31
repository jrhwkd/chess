# game pieces

class Cell
  attr_accessor :space, :value
  def initialize(space, value)
    @space = space
    @value = value
  end
end

class GamePiece
  def select_color(is_player_1)
    #player 1 is blue, player 2 is red
    is_player_1 ? "blue" : "red"
  end

  def calc_moves(current_space, possible_moves)
    moves = []
    possible_moves.each do |move|
      next if current_space[0] + move[0] > 7 || current_space[1] + move[1] > 7
      next if current_space[0] + move[0] < 0 || current_space[1] + move[1] < 0
      moves.push([current_space[0] + move[0], current_space[1] + move[1]])
    end
    return moves.uniq
  end

  # colorization
  def colorize(color_code, symbol)
    return "\e[#{color_code}m#{symbol}\e[0m"
  end

  def red(symbol)
    colorize(31, symbol)
  end

  def green(symbol)
    colorize(32, symbol)
  end

  def yellow(symbol)
    colorize(33, symbol)
  end

  def blue(symbol)
    colorize(34, symbol)
  end

  def pink(symbol)
    colorize(35, symbol)
  end

  def light_blue(symbol)
    colorize(36, symbol)
  end
end

class King < GamePiece
  attr_reader :color, :symbol, :space, :all_moves, :name
  attr_accessor :moves
  include KingData
  def initialize(space, is_player_1)
    @name = "king"
    @color = select_color(is_player_1)
    @space = space
    @color == "blue" ? @symbol = blue(SYMBOL) : @symbol = red(SYMBOL)
    @all_moves = POSSIBLE_MOVES
    @moves = calc_moves(@space, @all_moves)
    @moved = false
  end
end

class Queen < GamePiece
  attr_reader :color, :space, :symbol, :all_moves, :name
  attr_accessor :moves
  include QueenData
  def initialize(space, is_player_1)
    @name = "queen"
    @color = select_color(is_player_1)
    @space = space
    @color == "blue" ? @symbol = blue(SYMBOL) : @symbol = red(SYMBOL)
    @all_moves = POSSIBLE_MOVES
    @moves = calc_moves(@space, @all_moves)
  end
end

class Bishop < GamePiece
  attr_reader :color, :space, :symbol, :all_moves, :name
  attr_accessor :moves
  include BishopData
  def initialize(space, is_player_1)
    @name = "bishop"
    @color = select_color(is_player_1)
    @space = space
    @color == "blue" ? @symbol = blue(SYMBOL) : @symbol = red(SYMBOL)
    @all_moves = POSSIBLE_MOVES
    @moves = calc_moves(@space, @all_moves)
  end
end

class Knight < GamePiece
  attr_reader :color, :space, :symbol, :all_moves, :name
  attr_accessor :moves
  include KnightData
  def initialize(space, is_player_1)
    @name = "knight"
    @color = select_color(is_player_1)
    @space = space
    @color == "blue" ? @symbol = blue(SYMBOL) : @symbol = red(SYMBOL)
    @all_moves = POSSIBLE_MOVES
    @moves = calc_moves(@space, @all_moves)
  end
end

class Rook < GamePiece
  attr_reader :color, :space, :symbol, :all_moves, :name
  attr_accessor :moves
  include RookData
  def initialize(space, is_player_1)
    @name = "rook"
    @color = select_color(is_player_1)
    @space = space
    @color == "blue" ? @symbol = blue(SYMBOL) : @symbol = red(SYMBOL)
    @all_moves = POSSIBLE_MOVES
    @moves = calc_moves(@space, @all_moves)
    @moved = false
  end
end

class Pawn < GamePiece
  attr_reader :color, :space, :symbol, :all_moves, :name, :all_attacks
  attr_accessor :moves, :attacks
  include PawnData
  def initialize(space, is_player_1)
    @name = "pawn"
    @color = select_color(is_player_1)
    @space = space
    @color == "blue" ? @symbol = blue(SYMBOL) : @symbol = red(SYMBOL)
    @color == "blue" ? @all_moves = POSSIBLE_MOVES : @all_moves = switch_direction(POSSIBLE_MOVES)
    @color == "blue" ? @all_attacks = POSSIBLE_ATTACKS : @all_attacks = switch_direction(POSSIBLE_ATTACKS)
    @attacks = []
    @moves = calc_moves(@space, @all_moves)
  end

  def switch_direction(moves)
    moves.map do |move|
      move.map { |direction| direction * -1 }
    end
  end
end