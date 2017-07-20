require 'gosu'

HEIGHT = 400
WIDTH = 400
TILE = 10

class SnakeGame < Gosu::Window
  def initialize
    super WIDTH, HEIGHT, false
    @snake = Snake.new
    @fruit = Fruit.new
    self.update_interval = 100
  end

  def button_down(id)
    @snake.move(id)
  end

  def draw
    if @fruit.x == @snake.x && @fruit.y == @snake.y
      @fruit = Fruit.new
      @snake.grow_up
    end
    if @snake.tail[1..-1].include? [@snake.x, @snake.y]
      reset
    end

    @snake.draw
    @fruit.draw
  end

  def reset
    @snake = Snake.new
    @fruit = Fruit.new
  end
end

class Snake
  attr_reader :x, :y, :tail
  MIN_SIZE = 3

  def initialize
    @x = 100
    @y = 100

    @size = MIN_SIZE

    @tail = []
    @size.times do |i|
      x = @x
      y = @y - TILE * i
      @tail.push [x, y]
    end

    @vel_x = 0
    @vel_y = 0
  end

  def draw
    @x = (@x + @vel_x * TILE) % WIDTH
    @y = (@y + @vel_y * TILE) % HEIGHT
    if @vel_x != 0 or @vel_y != 0
      @tail.insert 0, [@x, @y]
      @tail.pop
    end

    @tail.each do |x , y|
      Gosu.draw_rect x, y, TILE, TILE, Gosu::Color::WHITE
    end
  end

  def grow_up
    @size += 1
    @tail.push @tail[-1]
  end

  def move(id)
    case id
    when Gosu::KB_LEFT
      @vel_x, @vel_y = -1, 0 unless @vel_x == 1
    when Gosu::KB_RIGHT
      @vel_x, @vel_y = 1, 0 unless @vel_x == -1
    when Gosu::KB_UP
      @vel_x, @vel_y = 0, -1 unless @vel_y == 1
    when Gosu::KB_DOWN
      @vel_x, @vel_y = 0, 1 unless @vel_y == -1
    end
  end
end

class Fruit
  attr_reader :x, :y

  def initialize
    @x = ((rand * WIDTH).to_i * TILE) % WIDTH
    @y = ((rand * HEIGHT).to_i * TILE) % HEIGHT
  end

  def draw
    Gosu.draw_rect @x, @y, TILE, TILE, Gosu::Color::RED
  end
end

SnakeGame.new.show
