require "krackle/version"
require "yaml"

module Krackle
  class Engine
    def initialize(hash)
      @hash = hash
    end

    def query(expression)
      Parser.new(Tokenizer.new(expression).tokenize).parse(@hash)
    end
  end

  class Tokenizer
    def initialize(str)
      @str = str
    end

    def tokenize
      scanner = StringScanner.new(@str)
      tokens = []
      until scanner.empty?
        case 
          when match = scanner.scan(/\[(\d+)?\]/)
            tokens << [:COLLECTION, (scanner[1] ? scanner[1].to_i : nil)]
          when match =scanner.scan(/\.?(\w+)/)
            tokens << [:KEY, scanner[1]]
          else
            raise "Say what? <#{scanner.peek(10).inspect}> at pos #{scanner.pos}"
          end
      end
      tokens
    end
  end

  class Parser
    def initialize(tokens)
      @tokens = tokens
    end

    def parse(hash)
      nodes = Array[hash]
      # p tokenize

      @tokens.each do |(token, value)|
        # p [token, value], nodes, "-"*30
        case token
        when :KEY
          nodes = nodes.map{ |node| node[value] }.compact
        when :COLLECTION
          if value
            nodes = nodes.map{ |node| node[value] }.compact
          else
            nodes = nodes.flatten.compact
          end
        end
      end

      nodes
    end
  end

  class CLI
    def initialize(args=ARGV)
      @expression, @path = args
    end

    def run
      io = if @path
        File.open(@path, 'r')
      else
        $stdin.tty? ? raise("Specify a file path") : $stdin
      end
      Engine.new(YAML.load(io.read)).query(@expression).join("\n")
    end
  end
end
