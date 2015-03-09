require "krackle/version"
require "yaml"

module Krackle
  class Engine
    def initialize(hash)
      @hash = hash
    end

    def query(expression)
      Query.new(@hash, expression).results
    end
  end

  class Query
    def initialize(hash, expression)
      @hash, @expression = hash, expression
    end

    def results
      nodes = Array[@hash]
      # p tokenize

      tokenize.each do |(token, value)|
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

  private
    def tokenize
      scanner = StringScanner.new(@expression)
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

  class CLI
  end
end
