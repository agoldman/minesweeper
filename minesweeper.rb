class Minesweeper

  attr_accessor :mines, :flagged_spots, :fringe_values, :checked_spots, :row, :col

  def initialize(row = 9, col = 9)
    @mines = []
    until @mines.count == 10
      bomb_spot = [rand(row+1), rand(col+1)]
      unless @mines.include?(bomb_spot)
        @mines << bomb_spot
      end
    end
    @flagged_spots = []
    @fringe_values = create_fringe
    @checked_spots = []
    @row = row
    @col = col

  end


  def create_fringe
    @mines.each |spot|
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
  end

  #add inbounds fringe spots to fringe hash
  def add_fringes(inbounds_fringes)
    inbound_fringes.each do |spot|
      if @fringe_values.key?(spot)
        @fringe_values[spot] += 1
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
    j = 0
    output_matrix = []
    matrix_sizer(output_matrix)
    while i < @row
      output_matrix << []
      while j < @col
        current_index = [i,j]
        if @checked_spots.include?[i,j]
          if @fringe_values.include?[i,j]
            output_matrix[i] << @fringe_value[i,j]
          elsif @mines.include?([i,j])
            output_matrix[i] << "B"
          else
            output_matrix[i] << "_"
          end
        elsif @flagged_spots.include?[i,j]
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


  def play
    gameover = false
    until gameover
      puts print_board
      puts "Please enter the position you'd like to play:"
      puts "Type 'r' to reveal a position or 'f' to flag a position:"
      input_type = gets.chomp.downcase
      puts "Example 0 7 represents Row 0 Column 7"
      input_array = gets.chomp.split(' ')
      until valid?(input_array)
        puts "Invalid Input"
        puts "Enter another spot"
        input_array = gets.chomp.split(' ')
      end
      place_move(input_array)
      gameover = @mines.include?(move) || won?(input_array) # user has selected a bomb spot
    end
    puts print_board
    if won?(input_array)
      puts "You Won!"
    else "BOMB!"
  end

  def place_move(input_type, input_array)
    #when we add a blank spot to the @checked_array, make sure to also add all non-fringe and fringe neighbors to that array too
    #what does clicking directly on a frige do? does it open any neighbors?
    if input_type == 'f'
      @flagged_spots << input_array
    end
    if input_type == 'r'
      if !in_bounds?(input_array)
      elsif @fringe_spots.includes?(input_array)
        @checked_spots << input_array
      else

        neighbours = [[spot[0] - 1, spot[1]],
                  [spot[0] - 1, spot[1] + 1],
                  [spot[0], spot[1] + 1],
                  [spot[0] + 1, spot[1] + 1],
                  [spot[0] + 1, spot[1]],
                  [spot[0] + 1, spot[1] - 1],
                  [spot[0], spot[1] - 1],
                  [spot[0] - 1, spot[1] - 1]]


        neighbours.each {|spot| place_move(input_type, spot)}
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



  end

  def valid?(position)
    in_bounds?(position) and
    !@checked_spots.include?(position) and
    !@flagged_spots.include?(position)
  end


end