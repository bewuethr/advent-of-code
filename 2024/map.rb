Point = Struct.new(:x, :y) do
  def to_s = "#{x}/#{y}"

  def +(other) = Point.new(x + other.x, y + other.y)
end

class Map
  attr_reader :rows

  def initialize(rows)
    @rows = rows
    @y_range = (0...@rows.length)
    @x_range = (0...@rows[0].length)
  end

  def include?(p) = @y_range.cover?(p.y) && @x_range.cover?(p.x)

  def at(p)
    return nil unless include?(p)
    @rows.dig(p.y, p.x)
  end

  def [](p) = at(p)

  def to_s = @rows.map(&:join).join("\n")

  def find_point(val)
    y = @rows.find_index { _1.include?(val) }
    x = @rows[y].find_index(val)
    Point.new(x, y)
  end

  def []=(p, val)
    @rows[p.y][p.x] = val
  end
end
