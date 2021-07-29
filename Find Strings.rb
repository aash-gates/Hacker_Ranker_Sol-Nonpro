require 'benchmark'

class String

  def right_substrings
    (0..length - 1).map { |i| self[i,length] }
  end

  def compare(str)
    return 0 if self[0] != str[0]

    top, bottom = [length, str.length].max - 1, 0

    loop {
      index = (top + bottom + 1) / 2
      is_previous_string_eq = self[bottom..index-1] == str[bottom..index-1]
      is_string_eq = is_previous_string_eq && self[index] == str[index]

      return index if is_previous_string_eq && !is_string_eq
      
      if is_string_eq
        bottom = index
      else
        top = index
      end

    }
  end

  def substrings
    return [] if empty?
    right_substrings + self[0..-2].substrings
  end

end

class Array
  def sort_and_uniq
    last = ""
    sort.select { |str| str != last && last = str }
  end
end

class FindStrings

  def initialize(fake_input = false, max_length = nil)
    override_gets(max_length) if fake_input
    num_strings = gets.to_i
    @strings = num_strings.times.map { gets.strip }
    num_queries = gets.to_i
    @queries = num_queries.times.map { gets.to_i }
  end

  def substrings
    return @substrings if @substrings
    @substrings = []
    substrings = @strings.map(&:right_substrings).flatten.sort_and_uniq
    substrings.each_with_index do |str, index|
      if index == substrings.length - 1 || str != substrings[index + 1][0..-2]
        @substrings << str
      end
    end
    @substrings
  end

  def substring_count
    last_string = ""
    num_substrings = 0
    start = 0

    @substring_count ||= substrings.map do |substring|
      start = last_string.compare(substring)
      last_string = substring
      num_substrings += (substring.length - start)
    end
  end

  def string_index(query)
    return nil if query > substring_count.last
    return 0 if substring_count.first >= query

    top, bottom = substring_count.length - 1, 0
    index = top / 2

    loop {
      return index if substring_count[index] >= query && substring_count[index - 1] < query
      if substring_count[index] < query
        bottom = index
      else
        top = index
      end
      index = (top + bottom + 1) / 2
    }
  end

  def get(query)
    index = string_index(query)

    return "INVALID" unless index
    last_str = index > 0 ? substrings[index - 1] : ""
    substring = substrings[index]
    start = last_str.compare(substring)
    length = query - (index > 0 ? substring_count[index - 1] : 0) + start
    substring[0, length]
  end

  def solve
    @queries.each do |query|
      puts get(query)
    end
  end

  def brute_force(query = nil)
    @brute_force ||= @strings.map(&:substrings).flatten.uniq.sort
    return @brute_force unless query
    @brute_force[query - 1] || "INVALID"
  end

  def override_gets(max_length = 100)
    chars = ('a'..'z').map
    strings = (1..50).map { (1..max_length).map { chars[rand(chars.length)] }.join }
    #strings = ('b'..'z').map { |chr| [(1999.times.map{'a'} + [chr]).join, (1998.times.map{'a'} + [chr] + ['b']).join]}.flatten
    queries = [500] + (1..499).map { rand(100000000) } + [100000000]
    @input = ['50'] + strings + queries
    def gets; @input.shift; end
  end

  def check
    result =  @queries.map { |q| get(q) == brute_force(q) }.inject(&:&)
    puts("PASSED") || return if result
    puts "FAILED"
    puts "BRUTE FORCE: #{brute_force.inspect}"
    puts "SUBSTRINGS: #{substrings.inspect}"
    @queries.each do |query|
      ss, bf = get(query), brute_force(query)
      puts "FAILED QUERY: QUERY => #{query}; BRUTE_FORCE => #{bf}; SUBSTRING => #{ss}" if ss != bf
    end
  end

  def benchmark(bf = false)
    alias :old_puts :puts unless respond_to?(:old_puts)
    def puts(input); nil; end
    Benchmark.bm do |bm|
      bm.report("SUBSTRINGS: ") { solve }
      bm.report("BRUTE FORCE: ") { brute_force(100000000) } if bf
    end
    def puts(input); old_puts(input); end
  end

end

def reload!
  load 'find_strings.rb'
end

@fs = FindStrings.new
@fs.solve

#@fs = FindStrings.new(true, 2000)
#@fs.benchmark
