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
  SYMBOL = "\u265a"
end

module QueenData
  QUEEN_MOVE_DIRECTIONS = (-7..7).to_a
  POSSIBLE_MOVES = create_queen_moves(QUEEN_MOVE_DIRECTIONS)
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "\u2655"
end

module BishopData
  BISHOP_MOVE_DIRECTIONS = (-7..7).to_a
  POSSIBLE_MOVES = create_bishop_moves(BISHOP_MOVE_DIRECTIONS)
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "\u2657"
end

module KnightData
  POSSIBLE_MOVES = [[-2, 1], [-1, 2], [1, 2], [2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "\u2658"
end

module RookData
  ROOK_MOVE_DIRECTIONS = (-7..7).to_a
  POSSIBLE_MOVES = create_rook_moves(ROOK_MOVE_DIRECTIONS)
  POSSIBLE_ATTACKS = POSSIBLE_MOVES
  SYMBOL = "\u2656"
end

module PawnData
  POSSIBLE_MOVES = [[0, 1], [0, 2]]
  POSSIBLE_ATTACKS = [[-1, 1], [1, 1]]
  SYMBOL = "\u2659"
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