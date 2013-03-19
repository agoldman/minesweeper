require 'yaml'
class Minesweeper

  attr_accessor :mines, :flagged_spots, :fringe_values, :checked_spots, :row, :col, :mine_num

  def initialize(row = 9, col = 9, mine_num = 10)
    @row = row
    @col = col
    @mines = []
    @mine_num = mine_num
    until @mines.count == mine_num
      bomb_spot = [rand(row+1), rand(col+1)]
      unless @mines.include?(bomb_spot)
        @mines << bomb_spot
      end
    end
    @flagged_spots = []
    @fringe_values = Hash.new
    create_fringe
    @checked_spots = []
    @already_checked_neighbors = []

  end

  def set_up
    until @mines.count == mine_num
      bomb_spot = [rand(row+1), rand(col+1)]
      unless @mines.include?(bomb_spot)
        @mines << bomb_spot
      end
    end
    @fringe_values = Hash.new
    create_fringe
  end


  def create_fringe
    @mines.each do |spot|
    #find all 8 spots neighboring a bomb
      temp_fringes = [[spot[0] - 1, spot[1]],
                  [spot[0] - 1, spot[1] + 1],
                  [spot[0], spot[1] + 1],
                  [spot[0] + 1, spot[1] + 1],
                  [spot[0] + 1, spot[1]],
                  [spot[0] + 1, spot[1] - 1],
                  [spot[0], spot[1] - 1],
                  [spot[0] - 1, spot[1] - 1]]
                  #filter for which of those spots are inbounds
      inbounds_fringes = temp_fringes.select { |current_spot| in_bounds?(current_spot) }
      add_fringes(inbounds_fringes)
    end
  end

  #add inbounds fringe spots to fringe hash
  def add_fringes(inbound_fringes)
    inbound_fringes.each do |spot|
      if @fringe_values.has_key?(spot)
        @fringe_values[spot] += 1
      elsif @mines.include?(spot) #don't add spot to fringes if it is a bomb
      else
        @fringe_values[spot] = 1
      end
    end
  end

  def in_bounds?(position)
    x = position[0]
    y = position[1]
    0 <= x && x <= @row && 0 <= y && y <= @col
  end

  def print_board
    i = 0
    output_matrix = []
    matrix_maker(output_matrix)
    while i <= @row
      #output_matrix << []
      j = 0
      while j <= @col
        current_index = [i,j]
        if @checked_spots.include?([i,j])
          if @fringe_values.include?([i,j])
            output_matrix[i] << @fringe_values[[i,j]].to_s
          elsif @mines.include?([i,j])
            output_matrix[i] << "B"
          else
            output_matrix[i] << "_"
          end
        elsif @flagged_spots.include?([i,j])
            output_matrix[i] << "F"
        else
          output_matrix[i] << "*"
        end
        j += 1
      end
      i += 1
    end

    output_matrix
  end

  def matrix_maker(output_matrix)
    (@row+1).times { |element| output_matrix << []}
 end


  def play
    p "#{@mines} bombs list"
    p "#{@fringe_values} fringes"
    puts "Please input number of rows to play."
    @row = gets.chomp.to_i
    puts "Please input number of columns to play."
    @col = gets.chomp.to_i
    puts "Please input number of bombs to search"
    @mine_num = gets.chomp.to_i
    set_up #build @mines and @fringe arrays
    gameover = false
    input_type = ""
    until gameover
      print_matrix = print_board
      print_matrix.each {|row| puts "#{row} \n"}
      puts "Please enter the position you'd like to play:"
      puts "Type 'r' to reveal a position or 'f' to flag a position or q or s to quit or save:"
      input_type = gets.chomp.downcase
      if input_type == "q"|| input_type == "s"
        break
      end
      puts "Example 0 7 represents Row 0 Column 7"
      temp_input_array = gets.chomp.split(' ')
      input_array = [temp_input_array[0].to_i, temp_input_array[1].to_i]
      until valid?(input_array)
        puts "Invalid Input"
        puts "Enter another spot"
        input_array = gets.chomp.split(' ')
      end
      if @mines.include?(input_array)
        @checked_spots << input_array
      else
        place_move(input_type, input_array)
      end
      gameover = (input_type != "f" && @mines.include?(input_array)) || won?(input_array) # user has selected a bomb spot
    end
    if input_type == "q"
    elsif input_type == "s"
      puts "Please input filename"
      filename = gets.chomp
      saved_game = self.to_yaml
      f = File.open(filename + ".yaml", "w")
      f.puts saved_game
      f.close
    else
      print_matrix = print_board
      print_matrix.each {|row| puts "#{row} \n"}
      if won?(input_array)
        puts "You Won!"
      else
        puts "BOMB!"
      end
    end
  end

  def place_move(input_type, input_array)
    if input_type == 'f'
      @flagged_spots << input_array
    end
    if input_type == 'r'
      if !in_bounds?(input_array) || @already_checked_neighbors.include?(input_array)
      elsif @fringe_values.has_key?(input_array)
        @already_checked_neighbors << input_array
        @checked_spots << input_array
      else
        neighbours = [[input_array[0] - 1, input_array[1]],
                  [input_array[0] - 1, input_array[1] + 1],
                  [input_array[0], input_array[1] + 1],
                  [input_array[0] + 1, input_array[1] + 1],
                  [input_array[0] + 1, input_array[1]],
                  [input_array[0] + 1, input_array[1] - 1],
                  [input_array[0], input_array[1] - 1],
                  [input_array[0] - 1, input_array[1] - 1]]

        neighbours.each do |spot|
          @checked_spots << input_array
          @already_checked_neighbors << input_array
           place_move(input_type, spot)
        end
      end
    end

  end


  def won?(move)
    won = true
    if @flagged_spots.count < 10
      won = false
    else @flagged_spots.each do |element|
        unless @mines.include?(element)
          won = false
          break
        end
      end
    end

   won
  end

  def valid?(position)
    in_bounds?(position) and
    !@checked_spots.include?(position) and
    !@flagged_spots.include?(position)
  end
end

m = nil
if ARGV.length > 0
  m = YAML.load_file(ARGV[0])
  ARGV.pop
else
  m = Minesweeper.new
end

m.play