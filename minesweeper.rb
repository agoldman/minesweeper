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


  def play
  end


end