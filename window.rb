require './dna_reader.rb'

class Dot < Struct.new(:x, :y)
  COLOR = Gosu::Color.new(128, 234, 234, 255)
  def draw(image)
    image.draw_quad(x-1, y-1, COLOR, x-1, y+1, COLOR, x+1, y+1, COLOR, x+1, y-1, COLOR, 0, :additive)
  end
end

class Window < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "DNA Vis"
    @x = 320
    @y = 240

    @velx = 0
    @vely = 0

    @reader = DnaReader.new('./dna.txt', :buffer_size => 20)
    @image = Gosu::Image.new(self, './dot.png', true)
    @dots = []
  end
  
  def update
    return if @reader.finished?

    velx, vely = @reader.to_vector    
    # ratio = Math.sqrt(velx ** 2 + vely ** 2)
    puts "speed : #{velx}, #{vely}"

    @x += velx
    @y += vely

    @reader.step
  end
  
  def draw
    puts "position: #{@x}, #{@y}"
    add_dot
    draw_dots
  end


  private

  def add_dot
    @dots << Dot.new(@x, @y)
  end

  def draw_dots
    @dots.each do |dot|
      dot.draw(self)
    end
  end

end