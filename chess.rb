
# 2 player chess
# played in the terminal
# created with ruby

require_relative './chess_data.rb'
require_relative './game_pieces.rb'

class Player
  @@player_num = 1
  attr_reader :name, :number, :color
  def initialize(name)
    @name = name
    @number = @@player_num
    @@player_num == 1? @color = "blue" : @color = "red"
    @@player_num += 1
  end
end

class Board
  attr_reader :board
  def initialize()
    @board = new_board
  end

  def new_board
    spaces = (0..7).to_a
    board = []
    spaces.each do |y|
      spaces.each do |x|
        cell = [x, y]
        # player 1
        if cell == [0, 0]
          board.push(Cell.new(cell, Rook.new(cell, true)))
        elsif cell == [1, 0]
          board.push(Cell.new(cell, Knight.new(cell, true)))
        elsif cell == [2, 0]
          board.push(Cell.new(cell, Bishop.new(cell, true)))
        elsif cell == [3, 0]
          board.push(Cell.new(cell, Queen.new(cell, true)))
        elsif cell == [4, 0]
          board.push(Cell.new(cell, King.new(cell, true)))
        elsif cell == [5, 0]
          board.push(Cell.new(cell, Bishop.new(cell, true)))
        elsif cell == [6, 0]
          board.push(Cell.new(cell, Knight.new(cell, true)))
        elsif cell == [7, 0]
          board.push(Cell.new(cell, Rook.new(cell, true)))
        elsif cell == [0, 1] || cell == [1, 1] || cell == [2, 1] || cell == [3, 1] || cell == [4, 1] || cell == [5, 1] || cell == [6, 1] || cell == [7, 1]
          board.push(Cell.new(cell, Pawn.new(cell, true)))
        # player 2
        elsif cell == [0, 7]
          board.push(Cell.new(cell, Rook.new(cell, false)))
        elsif cell == [1, 7]
          board.push(Cell.new(cell, Knight.new(cell, false)))
        elsif cell == [2, 7]
          board.push(Cell.new(cell, Bishop.new(cell, false)))
        elsif cell == [3, 7]
          board.push(Cell.new(cell, Queen.new(cell, false)))
        elsif cell == [4, 7]
          board.push(Cell.new(cell, King.new(cell, false)))
        elsif cell == [5, 7]
          board.push(Cell.new(cell, Bishop.new(cell, false)))
        elsif cell == [6, 7]
          board.push(Cell.new(cell, Knight.new(cell, false)))
        elsif cell == [7, 7]
          board.push(Cell.new(cell, Rook.new(cell, false)))
        elsif cell == [0, 6] || cell == [1, 6] || cell == [2, 6] || cell == [3, 6] || cell == [4, 6] || cell == [5, 6] || cell == [6, 6] || cell == [7, 6]
          board.push(Cell.new(cell, Pawn.new(cell, false)))
        else
          board.push(Cell.new(cell, nil))
        end
      end
    end
    return board
  end

  def display_board
    puts "\n"
    print_header
    print_row(8, create_row(0, 7))
    print_separator
    print_row(7, create_row(8, 15))
    print_separator
    print_row(6, create_row(16, 23))
    print_separator
    print_row(5, create_row(24, 31))
    print_separator
    print_row(4, create_row(32, 39))
    print_separator
    print_row(3, create_row(40, 47))
    print_separator
    print_row(2, create_row(48, 55))
    print_separator
    print_row(1, create_row(56, 63))
    print_separator
    print_header
    puts "\n"
  end

  def create_row(start, finish)
    row = []
    (start..finish).each do |cell|
      @board[cell].value != nil ? row.push(@board[cell].value.symbol) : row.push(' ')
    end
    return row
  end

  def print_row(row_num, row)
    string = ""
    row.each { |symbol| string += "#{symbol} | "}
    puts " #{row_num} |#{string}#{row_num}"
  end

  def print_separator
    puts "   -------------------------------"
  end

  def print_header
    puts "    a   b   c   d   e   f   g   h"
  end
end

class Game < GamePiece
  attr_reader :is_player_1
  attr_accessor 
  include BoardMapping
  def initialize
    @is_player_1 = true
    @board = Board.new
    @player_1 = get_player(1)
    @player_2 = get_player(2)
    @king_1 = find_king(@player_1)
    @king_2 = find_king(@player_2)
  end

  def get_player(player_num)
    player_num == 1 ? color = "\e[34mblue\e[0m" : color = "\e[31mred\e[0m"
    puts "Player #{player_num}, what is your name?"
    name = gets.chomp
    puts "#{name}, you are team #{player_num}, and your team color is #{color}!\n\n"
    return Player.new(name)
    #sleep 1
  end

  def switch_player
    @is_player_1 ? @is_player_1 = false : @is_player_1 = true
  end

  def find_king(player)
    @board.board.each do |cell|
      if !cell.value.nil?
        return cell.value if cell.value.name == 'king' && cell.value.color == player.color
      end
    end
  end

  def check?
    @is_player_1 ? king = @king_2 : king = @king_1
    @is_player_1 ? king_color = "red" : king_color = "blue"
    @board.board.each do |cell|
      if !cell.value.nil? && cell.value.color != king_color
        cell.value.moves.each do |move|
          if move == king.space
            puts "\n#{king} is under check!"
            return true
          end
        end
      end
    end
    return false
  end

  def checkmate?
    @is_player_1 ? king = @king_2 : king = @king_1
    check_mate_spaces = [king.space]
    @board.board.each do |cell|
      if !cell.value.nil?
        cell.value.moves.each do |move|
          check_mate_spaces.push(move) if king.moves.include?(move)
        end
      end
    end
    king.moves.sort == check_mate_spaces.sort ? true : false
  end

  def end_game_winner
    @board.display_board
    @is_player_1 ? player_num = "1" : player_num = "2"
    puts "\nCheckmate!\n\nPlayer #{player_num} wins!"
  end

  def play
    #intro
    until checkmate?
      @board.display_board

      # get piece
      piece_board_index = get_piece
      piece = @board.board[piece_board_index].value
      
      # calc piece moves
      if piece.name == 'pawn'
        calc_pawn_moves(piece)
      else
        piece.moves = calc_moves(piece.space, piece.all_moves)
      end
      
      display_moves(piece)

      # get move
      if piece.name == "pawn"
        # en passant
        move_to_space = get_move(piece)
        next if move_to_space.nil?
        if piece.enpassant_moves.include?(move_to_space)
          update_board_enpassant(piece, move_to_space)
          switch_player
          next
        end
        # promotion
        @is_player_1 ? last_space = 7 : last_space = 0
        if move_to_space[1] == last_space
          promotion(piece)
          switch_player
          next
        end
      elsif piece.name == "king"
        puts "Do you want to Castle? Yes or No"
        answer = gets.chomp.downcase until answer == "yes" || answer == "no" || answer == "y" || answer == "n"
        if answer == "yes" || answer == "y"
          castle(piece)
          answer = ""
          next if !castle
        else
          move_to_space = get_move(piece)
          next if move_to_space.nil?
        end
      else
        move_to_space = get_move(piece)
        next if move_to_space.nil?
      end

      # check move
      if piece.name == "knight"
        until check_move?(piece, move_to_space)
          move_to_space = re_run_check(piece)
          break if move_to_space.nil?
        end
        next if move_to_space.nil?
      else
        until check_move?(piece, move_to_space) && check_path?(piece.space, move_to_space)
          move_to_space = re_run_check(piece)
          break if move_to_space.nil?
        end
        next if move_to_space.nil?
      end

      # en passant
      # promotion

      update_board(piece, move_to_space) if !move_to_space.nil?  

      break if checkmate?
      check?

      switch_player
    end
    end_game_winner if checkmate?
    # end_game_draw if !checkmate?
  end 

  def get_column
    column_input = gets.chomp.downcase until COLUMN_MAPPING.keys.include?(column_input) || column_input == 'back'
    if column_input == 'back'
      column = 'back'
    else
      column = COLUMN_MAPPING[column_input]
    end
    return column
  end

  def get_row
    row_input = gets.chomp.to_i until ROW_MAPPING.keys.include?(row_input)
    row = ROW_MAPPING[row_input]
    return row
  end

  def get_piece
    @is_player_1 ? match_color = "red" : match_color = "blue"
    @is_player_1 ? player = @player_1 : player = @player_2
    until match_color == player.color
      puts "\n#{player.name}, for the piece you would like to move, what is the column?"
      column = get_column
      next if column == 'back'
      #sleep 1
      puts "\n#{player.name}, for the piece you would like to move, what is the row?"
      #sleep 1
      row = get_row
      space = [column, row]
      board_index = BOARD_MAPPING[space]
      match_color = @board.board[board_index].value.color if !@board.board[board_index].value.nil?
      puts "\nPlease select a piece on your team." if match_color != player.color
    end
    return board_index
  end

  def display_moves(piece)
    moves = []
    display_moves = "\n#{piece.name} moves are: "
    piece.moves.each do |move|
      display_move = []
      display_move.push(COLUMN_MAPPING.key(move[0]))
      display_move.push(ROW_MAPPING.key(move[1]))
      moves.push(display_move)
    end
    moves.each { |move| display_moves += " #{move}" }
    puts display_moves
  end

  def get_move(piece)(piece)
    @is_player_1 ? player = @player_1 : player = @player_2
    destination = "some space"
    until piece.moves.include?(destination)
      puts "\n#{player.name}, for the space you would like to move to, what is the column?"
      column = get_column
      break if column == 'back'
      #sleep 1
      puts "\n#{player.name}, for the space you would like to move to, what is the row?"
      #sleep 1
      row = get_row
      space = [column, row]
      board_index = BOARD_MAPPING[space]
      destination = @board.board[board_index].space
    end
    return space
  end

  def re_run_check(piece)(piece)
    @is_player_1 ? player = @player_1 : player = @player_2
    puts "\nThat move isn't legal, please enter a legal move."
    puts "To choose a different piece, type 'back'."
    @board.display_board
    move_board_space = get_move(piece)
    if move_board_space.nil?
      return nil
    else
      return move_board_space
    end
  end

  def check_move?(start, target)
    start.moves.include?(target) ? true : false
  end

  def check_path?(start, target)
    steps = [target[0] - start[0], target [1] - start[1]]
    #p "steps #{steps}"
    path = [(0..steps[0]).to_a, (0..steps[1]).to_a]
    path[0] = (steps[0]..0).to_a if steps[0] < 0
    path[1] = (steps[1]..0).to_a if steps[1] < 0
    #p "path #{path}"
    steps.max.abs > steps.min.abs ? i = steps.max.abs - 1 : i = steps.min.abs - 1
    #p "i #{i}"
    check_space = start.clone
    #p "check_space #{check_space}"
    for i in 1..i do
      check_space[0] = check_space[0] + path[0][i] if !path[0][i].nil?
      check_space[1] = check_space[1] + path[1][i] if !path[1][i].nil?
      #p "check_space looped #{check_space}"
      next if check_space == target
      pass = @board.board[BOARD_MAPPING[check_space]].value.nil?
      return false if pass == false
    end
    return true
  end

  def calc_pawn_moves(piece)
    piece.moves = calc_moves(piece.space, piece.all_moves)
    temp_all_attacks = calc_moves(piece.space, piece.all_attacks)
    temp_all_attacks.each do |attack|
      attack_cell = @board.board[BOARD_MAPPING[attack]]
      if !attack_cell.value.nil? && attack_cell.value.color != piece.color
        piece.moves.push(attack)
      end
    end

    #en passant
    piece_index = BOARD_MAPPING[piece.space]
    adjacent_cell_right = @board.board[piece_index + 1].value
    adjacent_cell_left = @board.board[piece_index - 1].value
    @is_player_1 ? operator = 1 : operator = -1
    if !adjacent_cell_right.nil? && adjacent_cell_right.color != piece.color && adjacent_cell_right.name == 'pawn' && adjacent_cell_right.num_of_moves == 1
      piece.enpassant_moves.push([adjacent_cell_right.space[0], adjacent_cell_right.space[1] + operator])
    end
    if !adjacent_cell_left.nil? && adjacent_cell_left.color != piece.color && adjacent_cell_left.name == 'pawn' && adjacent_cell_left.num_of_moves == 1
      piece.enpassant_moves.push([adjacent_cell_left.space[0], adjacent_cell_left.space[1] + operator])
    end
    (piece.enpassant_moves).each { |move| piece.moves.push(move) }
  end

  def update_board_enpassant(piece, move_to_space)
    move_to_index = BOARD_MAPPING[move_to_space]
    piece_index = BOARD_MAPPING[piece.space]
    piece.num_of_moves += 1 if piece.name == "pawn"
    piece.space = move_to_space
    @board.board[move_to_index].value = piece
    @board.board[piece_index].value = nil
    @is_player_1 ? operator = -1 : operator = 1
    p [move_to_space[0], move_to_space[1] + operator]
    @board.board[BOARD_MAPPING[[move_to_space[0], move_to_space[1] + operator]]].value = nil
  end

  def promotion(move_to_space)
    puts "\nPawn has been promoted!"
    puts "What would you like pawn to be promoted to?"
    puts "Enter: queen, bishop, knight, or rook"
    until promoted_to == "queen" || promoted_to == "knight" || promoted_to == "bishop" || promoted_to == "rook"
      promoted_to = gets.chomp.downcase
    end
    cell_value = @board.board[BOARD_MAPPING[move_to_space]].value
    case promoted_to
    when "queen"
      cell_value = Queen.new(move_to_space, @is_player_1)
    when "bishop"
      cell_value = Bishop.new(move_to_space, @is_player_1)
    when "knight"
      cell_value = Knight.new(move_to_space, @is_player_1)
    when "rook"
      cell_value = Rook.new(move_to_space, @is_player_1)
    end
  end

  def update_board(piece, move_to_space)
    move_to_index = BOARD_MAPPING[move_to_space]
    piece_index = BOARD_MAPPING[piece.space]
    piece.moved = true if piece.name == "king"
    piece.moved = true if piece.name == "rook"
    piece.num_of_moves += 1 if piece.name == "pawn"
    piece.space = move_to_space
    @board.board[move_to_index].value = piece
    @board.board[piece_index].value = nil
  end

  # special case - castling

  def check_castling
    if @is_player_1
      if @board.board[4].value.moved
        puts "Cannot castle King, King already moved."
        return false
      elsif @board.board[0].value.moved || @board.board[7].value.moved
        puts "Cannot castle King, Rook has moved."
        return false
      else
        return true
      end
    else
      if @board.board[60].value.moved
        puts "Cannot castle King, King has moved."
        return false
      elsif @board.board[56].value.moved || @board.board[63].value.moved
        puts "Cannot castle King, Rook has moved."
        return false
      else
        return true
      end
    end
  end

  def check_castling_spaces(column)
    if @is_player_1
      if column == 0
        if @board.board[1].value == nil && @board.board[2].value == nil && @board.board[3].value == nil
          return true
        else
          puts "Cannot castle, other pieces are blocking the path."
          return false
        end
      else
        if @board.board[5].value == nil && @board.board[6].value == nil
          return true
        else
          puts "Cannot castle, other pieces are blocking the path."
          return false
        end
      end
    else
      if column == 0
        if @board.board[57].value == nil && @board.board[58].value == nil && @board.board[59].value == nil
          return true
        else
          puts "Cannot castle, other pieces are blocking the path."
          return false
        end
      else
        if @board.board[61].value == nil && @board.board[62].value == nil
          return true
        else
          puts "Cannot castle, other pieces are blocking the path."
          return false
        end
      end
    end
  end

  def castle(piece)
    return if !check_castling
    puts "Select Rook column:"
    column = gets.chomp until column == 'a' || column == 'h'
    mapped_column = COLUMN_MAPPING[column]
    return if !check_castling_spaces(mapped_column)
    if @is_player_1
      # move king two spaces based on column, swap rook to far side of king
      if mapped_column == 0
        @board.board[2].value = piece
        piece.space = @board.board[2].space
        @board.board[3].value = @board.board[0].value
        @board.board[0].value = nil
        @board.board[4].value = nil
      else
        @board.board[6].value = piece
        piece.space = @board.board[6].space
        @board.board[5].value = @board.board[7].value
        @board.board[7].value = nil
        @board.board[4].value = nil
      end
    else
      if mapped_column == 0
        @board.board[57].value = piece
        piece.space = @board.board[57].space
        @board.board[58].value = @board.board[0].value
        @board.board[56].value = nil
        @board.board[60].value = nil
      else
        @board.board[62].value = piece
        piece.space = @board.board[62].space
        @board.board[61].value = @board.board[7].value
        @board.board[63].value = nil
        @board.board[60].value = nil
      end
    end
    return true
  end
end

test = Game.new
test.play
