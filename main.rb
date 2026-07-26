require_relative 'lib/tree'

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

tests = Tree.new([5, 1, 3, 74, 2, 86, 4])
tree.level_order { |n| puts n }
