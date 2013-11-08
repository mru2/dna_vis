require './dna_reader.rb'

class Dot < Struct.new(:x, :y)
  # COLOR = Gosu::Color.new(32, 234, 234, 255)
  def draw(image)
    image.dot.draw(x,y,0)
    # image.draw_quad(x-1, y-1, COLOR, x-1, y+1, COLOR, x+1, y+1, COLOR, x+1, y-1, COLOR, 0, :additive)
  end
end

class Window < Gosu::Window
  ZOOM = 1

  attr_reader :dot

  def initialize
    super 1024, 768, false
    self.caption = "DNA Vis"
    # @x = 320
    # @y = 240

    @cx, @cy = 512, 384
    @r, @thetha = 1, 0

    @reader = DnaReader.new('./dna.txt', :buffer_size => 4)
    @dot = Gosu::Image.new(self, './dot.png', true)
    @dots = []
  end
  
  def update
    return if @reader.finished?

    if (@reader.count % 1024 == 0)
      @cx, @cy = x, y
      @r = 1
    end

    velx, vely = @reader.to_vector    
    # ratio = Math.sqrt(velx ** 2 + vely ** 2)
    # @x += velx / ratio
    # @y += vely / ratio



    @thetha += vely / [@r.abs, 1].max
    @r      += velx

    @reader.step
  end
  
  def draw
    # puts "position: #{@r}, #{@thetha}"
    add_dot
    draw_dots
  end


  def x
    @cx + @r * Math.cos(@thetha * Math::PI) * ZOOM
  end

  def y
    @cy + @r * Math.sin(@thetha * Math::PI) * ZOOM
  end


  private

  def add_dot    
    @dots << Dot.new(x, y)
  end

  def draw_dots
    @dots.each do |dot|
      dot.draw(self)
    end
  end

end