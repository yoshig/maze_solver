class MazeSolver

  def initialize(diagonals_allowed = true)
    @maze = self.class.create_map
    @open_squares = self.list_all_opens

    @ending = find_ending
    @beginning = find_beginning

    @diagonals_allowed = diagonals_allowed
  end

  def self.create_map
    if ARGV.empty?
      maze = File.readlines('maze1.txt').map! do |line|
        line.chomp.split(//)
      end
    else
      maze = File.readlines(ARGV[0]).map! do |line|
        line.chomp.split(//)
      end
    end
    maze
  end

  def show_maze
    @maze.each { |row| p row }
  end

  def list_all_opens
    all_opens = []
    @maze.each_with_index do |columns, row|
      columns.each_with_index do |space, column|
        all_opens << [row, column] if space == " "
      end
    end
    all_opens
  end

  def all_available_moves(pos)
    row, col = pos
    all_moves_array = [
      [row + 1, col], [row - 1, col],
      [row, col + 1], [row, col - 1]
    ]

    if @diagonals_allowed
      all_moves_array += [
        [row + 1, col + 1], [row + 1, col - 1],
        [row - 1, col + 1], [row - 1, col - 1]
      ]
    end

    all_moves_array
  end

  def valid_move?(pos)
    row,col = pos
    @maze[row][col] == " " || @maze[row][col] == "E"
  end

  def trace_all_paths
    next_moves = [@beginning]
    found_end = false
    all_paths = {} 

    until found_end == true
      current_move = next_moves.pop
      new_possibilities = all_available_moves(current_move)
      new_possibilities.each do |next_move|
        if valid_move?(next_move) && !all_paths[next_move]
          next_moves.unshift(next_move)
          all_paths[next_move] = current_move
          if next_move == @ending
            found_end = true
          end
        end
      end
    end

    all_paths
  end

  def solve_maze
    find_beginning
  end

  def follow_breadcrumbs
    all_paths = trace_all_paths
    final_path = []

    next_move = @ending
    until next_move == @beginning
      final_path << next_move
      next_move = all_paths[next_move]
    end

    final_path
  end

  def mark_squares
    final_path = follow_breadcrumbs

    final_path.each do |pos|
      row, col = pos
      @maze[row][col] = "X"
    end

    show_maze
  end

  def find_point_of_interest(point)
    found_spot = []
    @maze.each_with_index do |columns, row|
      columns.each_with_index do |space, column|
        found_spot = [row, column] if space == point
      end
    end

    found_spot
  end

  def find_ending
    find_point_of_interest("E")
  end

  def find_beginning
    find_point_of_interest("S")
  end

end

# maze = MazeSolver.new
# maze.find_point_of_interest("S")
# # maze.show_maze
# maze.list_all_opens
# # p maze.all_available_moves([2,3])
# # p maze.follow_breadcrumbs
# maze.find_ending
# maze.mark_squares
