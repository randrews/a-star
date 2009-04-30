module AStar
  # A* search
  # Call with a block, this block gets called to determine
  # the neighbors of a given node.
  def self.search start, goal
    raise ArgumentError.new("Supply a block to find the neighbors of a node") unless block_given?

    # Add the starting node to the open list

    open_list=[start]
    open_cost_list={start => 0}

    closed={}
    parents={}

    # While the open list is not empty
    until open_list.empty?

      current_node = lowest(open_list, open_cost_list)
      current_cost = open_cost_list[current_node]

      if acceptable? goal, current_node
        # path complete
        return [current_node, build_path(current_node,parents)]
      else
        closed[current_node]=true
        open_list.delete current_node

        neighbors=yield(current_node)
        next if neighbors.nil?

        neighbors.each do |node|
          # unless it's already open or closed
          unless open_cost_list[node] or closed[node]
            open_list << node
            open_cost_list[node]=current_cost+1
            parents[node]=current_node
          end
        end
      end
    end

    nil # no path
  end

  private

  def self.lowest open, costs
    open.min do |a,b|
      costs[a]<=>costs[b]
    end
  end

  def self.acceptable? goal, current
    if goal.is_a? Proc
      goal[current]
    else
      goal==current
    end
  end

  def self.build_path final, parents
    path=[final]
    current=parents[final]

    until current.nil?
      path.unshift current
      current=parents[current]
    end

    path
  end
end
