# frozen_string_literal: true

# This module extends the Enumerable module
module Enumerable
  def my_each
    enum = to_enum(:each)
    return enum unless block_given?

    for value in enum do # rubocop:disable Style/For
      yield value
    end
  end

  def my_each_with_index
    enum = to_enum(:each_with_index)
    return enum unless block_given?

    index = 0
    my_each do |value|
      yield value, index
      index += 1
    end
  end

  def my_select
    enum = to_enum(:select)
    return enum unless block_given?

    new_arr = []
    my_each do |value|
      new_arr << value if yield(value)
    end
    new_arr
  end

  def my_all?
    return true unless block_given?

    my_each do |value|
      return false unless yield(value)
    end
    true
  end

  def my_any?
    return true unless block_given?

    my_each do |value|
      return true if yield(value)
    end
    false
  end

  def my_none?
    return false unless block_given?

    my_each do |value|
      return false if yield(value)
    end
    true
  end

  def my_count
    return size unless block_given?

    count = 0
    my_each do |value|
      count += 1 if yield(value)
    end
    count
  end

  def my_map
    enum = to_enum(:map)
    return enum unless block_given?

    new_arr = []
    my_each do |value|
      new_arr << value if yield(value)
    end
    new_arr
  end

  def my_map_proc(proc = nil)
    new_arr = []
    proc ||= proc { |x| x }
    my_each do |value|
      new_arr << value if proc.call(value)
    end
    new_arr
  end

  def my_inject(*memo)
    raise ArgumentError 'no block given' unless block_given?

    if memo.empty?
      memo = first
      arr = to_a.slice(1..-1)
    else
      memo = memo.first
      arr = to_a
    end
    arr.my_each do |value|
      memo = yield(memo, value)
    end
    memo
  end

  def multiply_els(arr)
    arr.my_inject { |a, b| a * b }
  end
end

# test

numbers = [1, 5, 7, 4, 9, 10]
words = %w[howdy partner how are you]
new_proc = proc { |i| i < 10 && i > 2 }

puts 'my_each vs. each'
puts(numbers.my_each { |object| object })
puts '--------------'
puts(numbers.each { object })

puts 'my_each_with_index vs. each_with_index'
words.my_each_with_index { |object, idx| puts "#{object} is at position #{idx}." }
puts '--------------'
words.each_with_index { |object, idx| puts "#{object} is at position #{idx}." }

puts 'my_select vs. select'
puts(numbers.my_select { |object| object if object.odd? })
puts '--------------'
puts(numbers.select { |object| object if object.odd? })

puts 'my_all? vs. all?'
puts(words.my_all? { |object| object.is_a?(String) })
puts '--------------'
puts(words.all? { |object| object.is_a?(String) })

puts 'my_any? vs. any?'
puts(words.my_any? { |object| object.length >= 10 })
puts '--------------'
puts(words.any? { |object| object.length >= 10 })

puts 'my_none? vs, none?'
puts(numbers.my_none? { |object| object == 7 })
puts '--------------'
puts(numbers.none? { |object| object == 7 })

puts 'my_count vs. count'
puts(words.my_count { |object| object.start_with?('h') })
puts '--------------'
puts(words.count { |object| object.start_with?('h') })

puts 'my_map vs. map'
puts(numbers.my_map { |object| object if object > 5 })
puts '--------------'
puts(numbers.map { |object| object if object > 5 })

puts 'my_map_proc vs map'
puts(numbers.my_map_proc(new_proc))
puts '--------------'
puts(numbers.map { |object| object if object < 10 && object > 2 })

puts 'my_inject vs. inject'
puts(numbers.my_inject { |memo, object| memo * object })
puts '--------------'
puts(numbers.inject { |memo, object| memo * object })
puts '--------------'
puts(numbers.my_inject(2) { |memo, object| memo * object })
puts '--------------'
puts(numbers.inject(2) { |memo, object| memo * object })

puts 'mutliply_els'
puts numbers.multiply_els([1, 2, 3])
