# Test file for GynColors theme - Ruby syntax.
# Comment: should be bright green (#00ff00)

require "json"
require "net/http"
require_relative "helpers"

# Constants
MAX_RETRIES = 5
VERSION = "1.0.0".freeze
PI = 3.14159

# Module
module Describable
  def describe
    "#{self.class.name}: #{to_s}"
  end
end

# Class with inheritance
class Animal
  include Describable
  attr_accessor :name, :legs
  attr_reader :species

  @@count = 0

  def initialize(name, legs: 4, species: "Unknown")
    @name = name
    @legs = legs
    @species = species
    @@count += 1
  end

  def self.count
    @@count
  end

  def speak
    raise NotImplementedError, "#{self.class} must implement #speak"
  end

  def to_s
    "#{@name} (#{@species}, #{@legs} legs)"
  end

  protected

  def internal_id
    object_id.to_s(16)
  end

  private

  def secret
    "hidden"
  end
end

class Dog < Animal
  TRICKS = %i[sit stay fetch roll_over].freeze

  def initialize(name, breed: "Mixed")
    super(name, legs: 4, species: "Canis familiaris")
    @breed = breed
  end

  def speak
    "Woof!"
  end

  def fetch(item)
    "#{@name} fetches the #{item}"
  end
end

# Strings and interpolation
name = "World"
greeting = "Hello, #{name}!"
single = 'no interpolation here: #{name}'
heredoc = <<~HEREDOC
  This is a heredoc
  with #{name} interpolation
  and multiple lines
HEREDOC

escaped = "line1\nline2\ttab\\backslash\x41"

# Symbols
status = :active
symbols = %i[pending active completed failed]

# Numbers
integer = 42
negative = -17
float = 3.14
scientific = 1.0e-7
hex = 0xFF
octal = 0o77
binary = 0b1010
large = 1_000_000
rational = 2/3r
complex = 3 + 4i

# Language constants
nothing = nil
yes = true
no = false

# Regular expressions
pattern = /^hello\s+(\w+)$/i
match = "hello world" =~ pattern
captures = "hello world".match(/(\w+)\s(\w+)/)

# Arrays and Hashes
array = [1, "two", :three, 4.0, nil, true]
hash = {
  name: "GynColors",
  version: VERSION,
  "string_key" => "value",
  42 => "numeric key"
}

# Blocks, Procs, Lambdas
doubled = [1, 2, 3, 4, 5].map { |x| x * 2 }
evens = (1..20).select(&:even?)

square = ->(x) { x ** 2 }
cube = proc { |x| x ** 3 }

[1, 2, 3].each do |num|
  puts "#{num}: square=#{square.call(num)}, cube=#{cube.call(num)}"
end

# Exception handling
begin
  result = 10 / 0
rescue ZeroDivisionError => e
  puts "Error: #{e.message}"
rescue StandardError => e
  puts "Unexpected: #{e.message}"
ensure
  puts "Always runs"
end

# Case/when with pattern matching (Ruby 3+)
def classify(value)
  case value
  in Integer => n if n > 0
    "positive: #{n}"
  in Integer => n
    "non-positive: #{n}"
  in String => s
    "string(#{s.length} chars)"
  in [Integer => first, *rest]
    "array starting with #{first}"
  in { name: String => name, **rest }
    "named: #{name}"
  in nil
    "nothing"
  else
    "unknown"
  end
end

# Method with keyword args and splat
def process(*args, key:, verbose: false, **options)
  return nil if args.empty?

  args.each_with_object({}) do |arg, memo|
    memo[arg] = options.fetch(arg, "default")
  end
end

# Open class / monkey patching
class String
  def palindrome?
    self == reverse
  end
end

# Enumerable chain
(1..100)
  .lazy
  .select { |n| n.odd? }
  .map { |n| n ** 2 }
  .reject { |n| n > 1000 }
  .first(10)

puts "racecar".palindrome?
puts Dog.new("Rex", breed: "Labrador").speak
