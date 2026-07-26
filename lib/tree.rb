# frozen_string_literal: true

require_relative 'node'
# Class for creating balanced BSTs
class Tree
  def initialize(arr)
    @root = build_tree(arr.sort.uniq)
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    return unless node

    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false)
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true)
  end

  def include?(value, node = @root)
    return false if node.nil?
    return true if node.data == value
    return true if include?(value, value < node.data ? node.left : node.right)

    false
  end

  def insert(value, node = @root, previous = nil)
    return if value == node&.data

    if node.nil?
      if value < previous.data then previous.left = Node.new(value)
      else previous.right = Node.new(value)
      end
      return
    end
    insert(value, value < node.data ? node.left : node.right, node)
  end

  def delete(value, node = @root, previous = nil)
    return if node.nil?

    delete(value, value < node.data ? node.left : node.right, node)
    return unless node.data == value

    if node.left.nil? && node.right.nil? then delete_no_children(node, previous)
    elsif !node.left.nil? && !node.right.nil? then delete_two_children(node, previous)
    else delete_one_child(node, previous)
    end
  end

  def level_order
    return :level_order.to_enum unless block_given?

    queue = [@root]
    until queue.empty?
      node = queue.shift
      next if node.nil?

      queue.push(node.left)
      queue.push(node.right)
      yield node.data
    end
    self
  end

  private

  def delete_no_children(node, previous)
    return @root = nil if previous.nil?

    if node == previous.left
      previous.left = nil
    else
      previous.right = nil
    end
  end

  def delete_one_child(node, previous)
    return @root = node.left || node.right if previous.nil?

    if node == previous.left
      previous.left = node.left || node.right
    else
      previous.right = node.left || node.right
    end
  end

  def delete_two_children(node, previous)
    successor = fetch_successor(node.right, node)
    if node == previous&.left
      previous.left = successor
    elsif node == previous&.right
      previous.right = successor
    else
      @root = successor
    end
    successor.left = node.left
    successor.right = node.right
  end

  def fetch_successor(node, previous)
    if node.left.nil?
      previous.left = node&.right
      return node
    end
    fetch_successor(node.left, node)
  end

  def build_tree(arr)
    return if arr.empty?

    mid = arr.length / 2
    root = Node.new(arr[mid])
    root.left = build_tree(arr[0...mid])
    root.right = build_tree(arr[mid + 1..])
    root
  end
end
