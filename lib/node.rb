# frozen_string_literal: true

# Class for nodes of balanced BST
class Node
  attr_accessor :left, :right
  attr_reader :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end
