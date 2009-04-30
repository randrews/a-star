require 'a_star.rb'

class Doublets
  def method_missing method,*args
    DoubletsIntermediate.new(method.to_s,@opts)
  end

  def self.method_missing method, *args
    DoubletsIntermediate.new(method.to_s,@opts)
  end

  def initialize opts={}
    @opts=opts
    DoubletsIntermediate('initialize',opts)
  end

  private

  class DoubletsIntermediate
    def initialize firstword,opts={}
      @firstword=firstword
      @opts=opts
    end

    def method_missing method, *args
      Doublets::DoubletsSolver.new(@opts).solve(@firstword,method.to_s)
    end
  end

  class DoubletsSolver

    def initialize opts={}
      opts||={}
      @dictionary=opts[:path]||'/usr/share/dict/words'
      @exclude=opts[:exclude]||[]
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
    
    def solve a,b
      (final, path)=AStar.search(a,b) do |current|
        possible=[]
        words(current.length).each do |word|
          possible << word if distance(current,word)==1
        end
        possible-@exclude
      end

      path
    end
  end
end
