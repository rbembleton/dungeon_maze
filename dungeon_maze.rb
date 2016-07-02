class Maze
  attr_accessor :grid, :scale
  
  # grid array: 
  #   [0]>>item (map, bread) or special space (start, finish)
  #   [1]>>up wall
  #   [2]>>right wall
  #   [3]>>down wall
  #   [4]>>left wall
    
    
  def initialize(size=10)
    @scale=size
    @grid=Array.new(@scale) {Array.new(@scale) {Array.new(5) {nil}}}
    fill_grid
  end
  
  def fill_grid
    number_of_tries=0
    until check_path?!=false do
      @grid=Array.new(@scale) {Array.new(@scale) {Array.new(5) {nil}}}
      
      @grid.each_index do |i|
        @grid[i].each_index do |i2|
          
          #edges
          @grid[i][i2][1]=true if i==0 && i2!=0
          @grid[i][i2][2]=true if i2==(@scale-1)
          @grid[i][i2][3]=true if i==(@scale-1) && i2!=(@scale-1)
          @grid[i][i2][4]=true if i2==0
          
          #random right wall (and left wall)
          if rand(2)==0 && i2!=(@scale-1)
            @grid[i][i2][2]=true 
            @grid[i][i2+1][4]=true
          end
          
          #random bottom wall (and top wall)
          if rand(2)==0 && i!=(@scale-1)
            @grid[i][i2][3]=true 
            @grid[i+1][i2][1]=true
          end
        
        
        end
      end
      
      number_of_tries+=1
      @grid[0][0][0]=:start
      @grid[@scale-1][@scale-1][0]=:finish
      
    end
    
    
    
    #display
    place_random_item(:map)
    place_random_item(:bread)
    
    #puts number_of_tries ## for testing
    # puts check_path?([0,0],[(@scale-1),(@scale-1)],:up)
    
  end

  
  def check_path?(check_to=[(@scale-1),(@scale-1)], check_from=[0,0], last_direction=:down)
    row=check_from[0]
    column=check_from[1]
    number_of_moves=0 # for testing
    
    ## for testing
    # display
    # puts "continue?"
    # continue=gets
    
    ## to take care of first calling and a blocked starting path
    return false if @grid[0][0][0]!=:start 
    return false if @grid[0][0][2]==true && @grid[0][0][3]==true
    
    until [row,column]==check_to do
      if ([row,column]==check_from && number_of_moves!=0)
        return false
      end
      
      if last_direction==:down
        next_check=:right
      elsif last_direction==:right
        next_check=:up
      elsif last_direction==:up
        next_check=:left
      elsif last_direction==:left
        next_check=:down
      end
      
      #puts next_check
      checked_four=0
      until checked_four>=4 do
        
        if next_check==:right
          if @grid[row][column][2]!=true
            column+=1
            checked_four=4
            last_direction=:right
          end
          checked_four+=1
          next_check=:down
        elsif next_check==:down
          if @grid[row][column][3]!=true
            row+=1
            checked_four=4
            last_direction=:down
          end
          checked_four+=1
          next_check=:left
        elsif next_check==:left
          if @grid[row][column][4]!=true
            column-=1
            checked_four=4
            last_direction=:left
          end
          checked_four+=1
          next_check=:up
        elsif next_check==:up
          if @grid[row][column][1]!=true
            row-=1
            checked_four=4
            last_direction=:up
          end
          checked_four+=1
          next_check=:right
        end
        
        if row==@scale
          row-=1
          last_direction=:up
        elsif row==-1
          row+=1
          last_direction=:down
        end
          
      end
      #puts last_direction
      number_of_moves+=1
      
      # if number_of_moves%100==0
      #   puts number_of_moves
      #   continue=gets
      # end
    end
    
    #puts "number of moves=" + number_of_moves.to_s # for testing
    number_of_moves
    
  end
  
  def place_random_item(item)
    item_placed=false
    attempts=0
    
    until item_placed==true
      rand_row=rand(@scale-1)
      rand_column=rand(@scale-1)
      
      num_walls=0
      1.upto(4) {|i| num_walls+=1 if @grid[rand_row][rand_column][i]==true}
      attempts+=1
      
      if num_walls==3 
        #puts rand_row.to_s + "," + rand_column.to_s
        if check_path?([0,0],[rand_row, rand_column],:down)!=false 
          if (check_path? < check_path?([0,0],[rand_row, rand_column],:down))
            @grid[rand_row][rand_column][0]=item
            item_placed=true
          end
        end
      end
      
      # if num_walls==2 && attempts>100 && rand_row!=0 && rand_column!=0 && rand_row!=@scale-1 && rand_column!=@scale-1
      #   puts rand_row.to_s + "," + rand_column.to_s
      #   if check_path?([0,0],[rand_row, rand_column],:down)!=false 
      #     if (check_path? < check_path?([0,0],[rand_row, rand_column],:down))
      #       @grid[rand_row][rand_column][0]=:item
      #       item_placed=true
      #     end
      #   end
      # end
      
      if attempts>100
        item_placed=true
      end
      
    end
    
  end

  def display(position=nil)
    to_display="Start\n"+"##  "+"##"*(@scale*2-1)+"\n"
    @grid.each_index do |i|
      row_one="##"
      row_two="##"
      
      @grid[i].each_index do |i2|
        if position!=nil && position[0]==i && position[1]==i2
          row_one+=":)"
        elsif @grid[i][i2][0]==nil 
          row_one+="  "
        elsif @grid[i][i2][0]==:map || @grid[i][i2][0]==:bread
          row_one+=@grid[i][i2][0].to_s[0]+" "
          #row_one+="mm"
        else
          row_one+="  "
        end
        
        if i2!=(@scale-1)
          @grid[i][i2][2]==true ? row_one+="##" : row_one+="  "
        else
          row_one+="##"
        end
        
        if i!=(@scale-1)
         @grid[i][i2][3]==true ? row_two+="##" : row_two+="  "
         row_two+="##"
        end
        
      end
      
      i!=(@scale-1) ? row_one+="\n" : row_two=""
      
      to_display+=row_one+row_two+"\n"
    end
    to_display+="##"*(@scale*2-1)+"  ##\n"+"    "*(@scale-1) + "Finish"
    to_display
  end
  
  
  def randomize
      
      
      
  end
  
  
  
  
    
end


if __FILE__ == $PROGRAM_NAME
  
  mymaze=Maze.new
  puts mymaze.display
  
  

end