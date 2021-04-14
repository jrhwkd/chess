require 'json'

def create_all_spaces
  spaces = (0..7).to_a
  board = {}
  i = 0
  spaces.each do |y|
    spaces.each do |x|
      board[[x, y]] = i
      i += 1
    end
  end
  return board
end      

def create_king_moves(possible_moves)
  moves = []
  possible_moves.each do |x|
    possible_moves.each do |y|
      moves.push([x, y]) unless [x, y] == [0, 0]
    end
  end
  return moves
end

def create_queen_moves(possible_moves)
  moves = []
  possible_moves.each do |move|
    next if move == 0
    moves.push([move, 0])
    moves.push([0, move])
    moves.push([move, move])
    moves.push([move, move * -1])
  end
  return moves
end

def create_bishop_moves(possible_moves)
  moves = []
  possible_moves.each do |move|
    next if move == 0
    moves.push([move, move])
    moves.push([move, move * -1])
  end
  return moves
end

def create_rook_moves(possible_moves)
  moves = []
  possible_moves.each do |move|
    next if move == 0
    moves.push([move, 0])
    moves.push([0, move])
  end
  return moves
end

module KingData
  KING_MOVE_DIRECTIONS = (-1..1).to_a
  POSSIBLE_MOVES = create_king_moves(KING_MOVE_DIRECTIONS)
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "Kg" #"\u265a"
end

module QueenData
  QUEEN_MOVE_DIRECTIONS = (-7..7).to_a
  POSSIBLE_MOVES = create_queen_moves(QUEEN_MOVE_DIRECTIONS)
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "Qn" #"\u2655"
end

module BishopData
  BISHOP_MOVE_DIRECTIONS = (-7..7).to_a
  POSSIBLE_MOVES = create_bishop_moves(BISHOP_MOVE_DIRECTIONS)
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "Bp" #"\u2657"
end

module KnightData
  POSSIBLE_MOVES = [[-2, 1], [-1, 2], [1, 2], [2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "Kn" #"\u2658"
end

module RookData
  ROOK_MOVE_DIRECTIONS = (-7..7).to_a
  POSSIBLE_MOVES = create_rook_moves(ROOK_MOVE_DIRECTIONS)
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "Rk" #"\u2656"
end

module PawnData
  POSSIBLE_MOVES = [[0, 1], [0, 2]]
  POSSIBLE_ATTACKS = [[-1, 1], [1, 1]]
  SYMBOL = "pn" #"\u2659"
end

module BoardMapping
  COLUMN_MAPPING = {
    'a'=> 0,
    'b'=> 1,
    'c'=> 2,
    'd'=> 3,
    'e'=> 4,
    'f'=> 5,
    'g'=> 6,
    'h'=> 7
  }

  ROW_MAPPING = {
    8=> 0,
    7=> 1,
    6=> 2,
    5=> 3,
    4=> 4,
    3=> 5,
    2=> 6,
    1=> 7
  }

  BOARD_MAPPING = create_all_spaces
end

module BasicSerialization
  @@serializer = JSON

  def serialize
    obj = {}
    instance_variables.each do |var|
      if var == :@is_player_1
        obj[var] = instance_variable_get(var)
      elsif var == :@board
        board = []
        @board.board.each do |cell|
          cell_obj = {}
          cell_obj[:@space] = cell.space
          if cell.value == nil
            cell_obj[:@value] = nil
          else
            cell_value = {}
            cell_value[:@name] = cell.value.name
            cell_value[:@color] = cell.value.color
            cell_value[:@space] = cell.value.space
            cell_value[:@symbol] = cell.value.symbol
            cell_value[:@all_moves] = cell.value.all_moves
            cell_value[:@moves] = cell.value.moves
            cell_value[:@moved] = cell.value.moved if defined?(cell.value.moved)
            cell_value[:@num_of_moves] = cell.value.num_of_moves if defined?(cell.value.num_of_moves)
            cell_obj[:@value] = cell_value
          end
          board.push(cell_obj)
        end
        obj[var] = board
      elsif var == :@player_1 || var == :@player_2
        player_var = {}
        var == :@player_1 ? player = @player_1 : player = @player_2
        player_var[:@name] = player.name
        player_var[:@number] = player.number
        player_var[:@color] = player.color
        obj[var] = player_var
      elsif var == :@players
        obj[var] = [:@player_1, :@player_2]
      elsif var == :@king_1 || var == :@king_2
        var == :@king_1 ? king = @king_1 : king = @king_2
        obj[var] = king
      end
    end
    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.parse(string)
    obj.keys.each do |key|
      instance_variable_set(key, obj[key])
    end
    
    # set board
    loaded_board = []
    @board.each do |cell|
      space = cell["@space"]
      value = cell["@value"]
      if value == nil
        piece = nil
      else
        value["@color"] == "blue" ? is_player_1 = true : is_player_1 = false
        case value["@name"]
        when "king"
          piece = King.new(space, is_player_1)
        when "queen"
          piece = Queen.new(space, is_player_1)
        when "bishop"
          piece = Bishop.new(space, is_player_1)
        when "knight"
          piece = Knight.new(space, is_player_1)
        when "rook"
          piece = Rook.new(space, is_player_1)
        when "pawn"
          piece = Pawn.new(space, is_player_1, value["@num_of_moves"])
        end
      end
      loaded_board.push(Cell.new(space, piece))
    end
    @board = Board.new
    @board.board = loaded_board

    # set player 1
    player_1_name = @player_1["@name"]
    @player_1 = Player.new(player_1_name, 1)
    
    # set player 2
    player_2_name = @player_2["@name"]
    @player_2 = Player.new(player_2_name, 2)

    # set players
    @players = [@player_1, @player_2]

    # find kings
    @king_1 = find_king(@player_1)
    @king_2 = find_king(@player_2)
  end
end

# class String
#   # colorization
#   def colorize(color_code)
#     "\e[#{color_code}m#{self}\e[0m"
#   end

#   def red
#     colorize(31)
#   end

#   def green
#     colorize(32)
#   end

#   def yellow
#     colorize(33)
#   end

#   def blue
#     colorize(34)
#   end

#   def pink
#     colorize(35)
#   end

#   def light_blue
#     colorize(36)
#   end
# end

# test = String.new("\u2659")
# puts test.red

# test = create_all_spaces
# space = [0, 1]
# p test[space]