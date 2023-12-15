#!/usr/bin/env ruby

def is_symmetry_line?(lines, (a, b))
  while a > 0 && b < lines.length - 1
    a -= 1
    b += 1
    return false if lines[a] != lines[b]
  end

  true
end

def find_symmetry(lines)
  idx_pairs = []
  lines.each_with_index.each_cons(2) do |((line_a, idx_a), (line_b, idx_b))|
    idx_pairs << [idx_a, idx_b] if line_a == line_b
  end

  return nil if idx_pairs.empty?

  sym_lines = idx_pairs.select { |pair| is_symmetry_line?(lines, pair) }
  return nil if sym_lines.empty?

  sym_lines.map { |pair| pair.first + 1 }
end

def summarize(pattern)
  lines = pattern.split("\n")

  count = find_symmetry(lines)
  original = if count
    100 * count[0]
  else
    find_symmetry(lines.map(&:chars).transpose.map(&:join))[0]
  end

  counts = Set[original]

  (0...lines.length).each do |y|
    (0...lines[0].length).each do |x|
      new_lines = lines.map(&:clone)
      new_lines[y][x] = (new_lines[y][x] == "#") ? "." : "#"

      count_new = find_symmetry(new_lines)
      count_new&.each { |c| counts.add(100 * c) }

      count_new = find_symmetry(new_lines.map(&:chars).transpose.map(&:join))
      count_new&.each { |c| counts.add(c) }
    end

    break if counts.size == 2
  end

  counts.to_a.find { |c| c != original }
end

file = File.open(ARGV[0])

patterns = file.readlines.join.split("\n\n")

puts patterns.sum { |p| summarize(p) }
