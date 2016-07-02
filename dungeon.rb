require_relative "dungeon_maze"

# grid array: 
  #   [0]>>item (map, bread) or special space (start, finish)
  #   [1]>>up wall
  #   [2]>>right wall
  #   [3]>>down wall
  #   [4]>>left wall

class Dungeon
  attr_accessor :maze, :position, :have_map, :direction, :scale, :have_bread, :positions_visited
  
  
  def initialize(maze=Maze.new(6), scale=5)
    @maze=maze
    @position=[0,0]
    @have_map=false
    @have_bread=false
    @direction=:down
    @scale=scale
    @positions_visited=[[0,0]]
  end
  
  def play
    until won? do 
      move
    end
    system 'clear'
    puts "\n"
    display_position
    puts "You WONNNNNN"
    
  end
  
  def move
    system 'clear'
    puts "\n"
    display_position
    puts "\n"
    puts "  --^--"
    puts " /  W  \\"
    puts "< A + D >"
    puts " \\  S  /"
    puts "  --v--\n\n"
    
    if @maze.grid[@position[0]][@position[1]][0]==:map
      puts "You found the map!!! Lucky you." 
      @have_map=true
      @maze.grid[@position[0]][@position[1]][0]=nil
    end
    
     if @maze.grid[@position[0]][@position[1]][0]==:bread
      puts "You found the bread!!! That should be helpful, we'll use it to leave crumbs as we go." 
      @have_bread=true
      @maze.grid[@position[0]][@position[1]][0]=nil
    end

    puts "Which direction would you like to go?"
    to_move=gets.chomp.downcase
    
    until ['a','w','d','s'].include?(to_move) do
      puts "Not a valid move, try again (a, w, d,or s)"
      to_move=gets.chomp.downcase
    end
    
    if to_move=='a' 
      new_direction=movement_hash[@direction][0]
    elsif to_move=='w'
      new_direction=movement_hash[@direction][1]
    elsif to_move=='d'
      new_direction=movement_hash[@direction][2]
    elsif to_move=='s'
      new_direction=movement_hash[@direction][3]
    end
    
    if new_direction==:left && @maze.grid[@position[0]][@position[1]][4]!=true
      @position[1]-=1 unless @position[1]==(0)
    elsif new_direction==:down && @maze.grid[@position[0]][@position[1]][3]!=true
      @position[0]+=1 unless @position[0]==(@maze.scale-1)
    elsif new_direction==:right && @maze.grid[@position[0]][@position[1]][2]!=true
      @position[1]+=1 unless @position[1]==(@maze.scale-1)
    elsif new_direction==:up && @maze.grid[@position[0]][@position[1]][1]!=true
      @position[0]-=1 unless @position[0]==(0)
    end
    
    @direction=new_direction
    
  end
  
  def movement_hash
    {
      :down => [:right, :down, :left, :up],
      :right => [:up, :right, :down, :left],
      :up => [:left, :up, :right, :down],
      :left => [:down, :left, :up, :right]
      
    }
    
  end
  
  def won?
    position==[@maze.scale-1,@maze.scale-1] ? true : false
  end
    
  
  def display_position
    wall_array=@maze.grid[@position[0]][@position[1]]
    scale_v=@scale*3/4
    other_positions=[nil,nil,nil,nil]
    
    if @direction==:down
      left_side=wall_array[2]
      right_side=wall_array[4]
      front=wall_array[3]
      other_positions[0]=[@position[0],@position[1]+1] if @maze.grid[@position[0]][@position[1]+1]!=true && @maze.grid[@position[0]][@position[1]+1]!=nil
      other_positions[1]=[@position[0]+1,@position[1]] if (@position[0]+1)<@maze.scale && @maze.grid[@position[0]+1][@position[1]]!=true
      other_positions[2]=[@position[0],@position[1]-1] if @maze.grid[@position[0]][@position[1]-1]!=true && @maze.grid[@position[0]][@position[1]-1]!=nil
      other_positions[3]=[@position[0]-1,@position[1]] if @maze.grid[@position[0]-1][@position[1]]!=true && @maze.grid[@position[0]-1][@position[1]]!=nil
    elsif @direction==:right
      left_side=wall_array[1]
      right_side=wall_array[3]
      front=wall_array[2]
      other_positions[0]=[@position[0]-1,@position[1]] if @maze.grid[@position[0]-1][@position[1]]!=true && @maze.grid[@position[0]-1][@position[1]]!=nil
      other_positions[1]=[@position[0],@position[1]+1] if @maze.grid[@position[0]][@position[1]+1]!=true && @maze.grid[@position[0]][@position[1]+1]!=nil
      other_positions[2]=[@position[0]+1,@position[1]] if @maze.grid[@position[0]+1][@position[1]]!=true && @maze.grid[@position[0]+1][@position[1]]!=nil
      other_positions[3]=[@position[0],@position[1]-1] if @maze.grid[@position[0]][@position[1]-1]!=true && @maze.grid[@position[0]][@position[1]-1]!=nil
    elsif @direction==:up
      left_side=wall_array[4]
      right_side=wall_array[2]
      front=wall_array[1]
      other_positions[0]=[@position[0],@position[1]-1] if @maze.grid[@position[0]][@position[1]-1]!=true && @maze.grid[@position[0]][@position[1]-1]!=nil
      other_positions[1]=[@position[0]-1,@position[1]] if @maze.grid[@position[0]-1][@position[1]]!=true && @maze.grid[@position[0]-1][@position[1]]!=nil
      other_positions[2]=[@position[0],@position[1]+1] if @maze.grid[@position[0]][@position[1]+1]!=true && @maze.grid[@position[0]][@position[1]+1]!=nil
      other_positions[3]=[@position[0]+1,@position[1]] if @maze.grid[@position[0]+1][@position[1]]!=true && @maze.grid[@position[0]+1][@position[1]]!=nil
    elsif @direction==:left
      left_side=wall_array[3]
      right_side=wall_array[1]
      front=wall_array[4]
      other_positions[0]=[@position[0]+1,@position[1]] if @maze.grid[@position[0]+1][@position[1]]!=true && @maze.grid[@position[0]+1][@position[1]]!=nil
      other_positions[1]=[@position[0],@position[1]-1] if @maze.grid[@position[0]][@position[1]-1]!=true && @maze.grid[@position[0]][@position[1]-1]!=nil
      other_positions[2]=[@position[0]-1,@position[1]] if @maze.grid[@position[0]-1][@position[1]]!=true && @maze.grid[@position[0]-1][@position[1]]!=nil
      other_positions[3]=[@position[0],@position[1]+1] if @maze.grid[@position[0]][@position[1]+1]!=true && @maze.grid[@position[0]][@position[1]+1]!=nil
    end
    
    if left_side==true 
      p_l="|" 
      b_l="--"
    else
      p_l="#"
      @positions_visited.include?([other_positions[0][0],other_positions[0][1]]) && have_bread==true ? b_l="<>" : b_l="--" 
    end
    
    if right_side==true  
      p_r="|" 
      b_r="--"
    else
      p_r="#"
      @positions_visited.include?([other_positions[2][0],other_positions[2][1]]) && have_bread==true ? b_r="<>" : b_r="--"
    end
    
    if front==true 
      p_f="|" 
      b_f="--"
    else
      p_f="#"
      @positions_visited.include?([other_positions[1][0],other_positions[1][1]]) && have_bread==true ? b_f="<>" : b_f="--"
    end
    
    
    if wall_array[0]==:map || wall_array[0]==:bread
      p_i=["/","^^","\\", "|", "??"]
    else
      p_i=["-","--","-","-","--"]
    end
    
    if @have_bread==true && @positions_visited.include?([other_positions[3][0],other_positions[3][1]])
      b_h="<>"
    else
      b_h="--"
    end
    
    @positions_visited.push(@position.dup) if @have_bread==true
    
    if @maze.grid[@position[0]][@position[1]][0]==:finish
      p_f=" " if @direction==:down
      p_r=" " if @direction==:right
    end
    
    if @maze.grid[@position[0]][@position[1]][0]==:start
      p_f="S" if @direction==:up
      p_r="S" if @direction==:left
    end
    
    to_display=("||||"*@scale+"----------------"*@scale+"||||"*@scale+"\n")*@scale
    to_display+=("||||||||||"*@scale+p_f*4*@scale+"||||||||||"*@scale+"\n")*scale_v
    to_display+=("|||"*@scale+p_l*2*@scale+"||||"*@scale+p_f*6*@scale+"||||"*@scale+p_r*2*@scale+"|||"*@scale+"\n")*scale_v
    to_display+=("|||"*@scale+p_l*3*@scale+"|||"*@scale+p_f*6*@scale+"|||"*@scale+p_r*3*@scale+"|||"*@scale+"\n")*3*scale_v
    to_display+=("|||"*@scale+p_l*3*@scale+"|||"*@scale+"--"*@scale+b_f*@scale+"--"*@scale+"|||"*@scale+p_r*3*@scale+"|||"*@scale+"\n")*scale_v
    to_display+=("|||"*@scale+p_l*3*@scale+"----"*@scale+p_i[0]*@scale+p_i[1]*@scale+p_i[2]*@scale+"----"*@scale+p_r*3*@scale+"|||"*@scale+"\n")*scale_v
    to_display+=("|||"*@scale+p_l*@scale+b_l*@scale+"----"*@scale+p_i[3]*@scale+p_i[4]*@scale+p_i[3]*@scale+"----"*@scale+b_r*@scale+p_r*@scale+"|||"*@scale+"\n")*scale_v
    to_display+=("||"*@scale+"---------"*@scale+b_h*@scale+"---------"*@scale+"||"*@scale+"\n")*scale_v
    
    
    map_lines=@maze.display(@position).split("\n") if @have_map==true
    map_lines=[] if @have_map==false
    pic_lines=to_display.split("\n")
    
    until pic_lines.length>=(map_lines.length+2) do
      pic_lines.push(' '*24*@scale)
    end
    
    0.upto(pic_lines.length-1) do |i|
      single_line=pic_lines[i]
      single_line+="        "+" "*(@maze.scale*2-1)+"MAP" if @have_map==true && i==0
      single_line+=("        "+map_lines[i-2]) if @have_map==true && i>1 && i<(map_lines.length+2)
      puts single_line
    end
    
    #puts @positions_visited.to_s
  end
    
    
end




if __FILE__ == $PROGRAM_NAME
  puts "Welcome to the Dungeon, please choose a level 1-5: 1 is the easiest, 5 is the hardest."
  level=gets.chomp.to_i
  
  until level>0 && level<6 do
    puts "That wasn't a valid option, try again"
    level=gets.chomp.to_i
  end
  
  level_hash={1=>4,2=>6,3=>8,4=>10,5=>12}
  
  mydungeon=Dungeon.new(Maze.new(level_hash[level]), scale=5)
  mydungeon.play
    
    
    
end






    # |||--------------|||
    # |||||||-####-|||||||
    # ||##|||######|||##||
    # ||###||######||###||
    # ||###||######||###||
    # ||###||######||###||
    # ||###||------||###||
    # ||###---/^^\---###||
    # ||#-----|??|-----#||
    # |------------------|