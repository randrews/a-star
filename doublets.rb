require 'a_star.rb'

class Solver

  def initialize path='/usr/share/dict/words'
    @dictionary=path
    @words={}
  end

  def words length
    return @words[length] unless @words[length].nil?

    @words[length]=[]
    File.open(@dictionary) do |file|
      file.each do |line|
        line=line.chomp
        @words[length] << line.downcase if line.length==length
      end
    end
    @words[length]=@words[length].uniq
  end

  def distance a,b
    if a.length > b.length
      distance b,a
    else
      diffs=0
      n=0
      a.each_byte do |char|
        diffs+=1 if b[n]!=char
        n+=1
      end
      diffs
    end
  end

  def forward current
    possible=[]
    words(current.length).each do |word|
      possible << word if distance(current,word)==1
    end
    possible
  end

  def solve a,b
    AStar.search(a,b){|word| forward(word)}
  end
end
