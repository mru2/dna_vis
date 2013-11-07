class DnaReader

  CHAR_MAP = {
    'A' => [-1,  0],
    'T' => [ 1,  0],
    'G' => [ 0, -1],
    'C' => [ 0,  1]
  }

  attr_reader :count, :buffer
  
  def initialize(file_path, opts={})
    @buffer_size = opts[:buffer_size] || 4
    @file = File.open(file_path, 'r')
    @count = 1

    # Fill the buffer first
    @buffer = []
    @buffer_size.times do
      @buffer << next_char!
    end
  end

  def step
    c = next_char!
    @buffer.tap(&:shift).push(c)
    @count += 1
  end

  def to_s
    @buffer.join
  end

  def to_vector
    ratio = @buffer_size.to_f
    @buffer.inject [0,0] do |acc, char|
      delta   = CHAR_MAP[char]
      acc[0] += delta[0] / ratio
      acc[1] += delta[1] / ratio
      acc
    end
  end

  def finished?
    @file.eof?
  end


  private

  def next_char!
    c = @file.readchar
    %w(A T G C).include?(c) ? c : next_char!
  end

end