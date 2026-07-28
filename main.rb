# frozen_string_literal: true

require_relative 'lib/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
puts "tree balanced? #{tree.balanced?}"
puts 'level order'
p tree.level_order.to_a
puts 'preorder'
p tree.preorder.to_a
puts 'inorder'
p tree.inorder.to_a
puts 'postorder'
p tree.postorder.to_a
new_nums = Array.new(5) { rand(101..200) }
p "inserting numbers above 100: #{new_nums}"
new_nums.each { |n| tree.insert(n) }
puts "tree balanced? #{tree.balanced?}"
puts 'rebalancing'
tree.rebalance
puts "tree balanced? #{tree.balanced?}"
puts 'level order'
p tree.level_order.to_a
puts 'preorder'
p tree.preorder.to_a
puts 'inorder'
p tree.inorder.to_a
puts 'postorder'
p tree.postorder.to_a
puts tree.pretty_print
