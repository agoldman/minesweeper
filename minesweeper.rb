class Minesweeper

  attr_accessor :mines, :flagged_spots, :finge_values, :checked_spots

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


  end


  def create_fringe
    @mines.each |spot|
    temp_fringes =[spot[0] - 1, spot[1]]
    fringe2 =[spot[0] - 1, spot[1] + 1]
    fringe3 =[spot[0], spot[1] + 1]
    fringe4 =[spot[0] + 1, spot[1] + 1]
    fringe5 =[spot[0] + 1, spot[1]]
    fringe6 =[spot[0] + 1, spot[1] - 1]
    fringe7 =[spot[0], spot[1] - 1]
    fringe8 =[spot[0] - 1, spot[1] - 1]



    end
  end

  def in_bounds?(position, row, col)
    x = position[0]
    y = position[1]
    0 <= x && x <= row && 0 <= y && y <= col
  end


  def play
  end


end