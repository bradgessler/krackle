require "krackle/version"
require "yaml"

module Krackle
  class Engine
    def initialize(hash)
      @hash = hash
    end

    def query(expression)
      Query.new(@hash, expression)
    end
  end

  class Query
    def initialize(hash, expression)
      @hash, @expression = hash, expression
    end

    def results
      nodes = Array[@hash]

      tokens.each do |(token, value)|
        p token, value
        case token
        when :KEY
          nodes = nodes.map{ |node| node[value] }.compact.flatten
        when :COLLECTION
          if value
            nodes = nodes.map{ |node| node[value] }
          end
        end
      end

      nodes
    end

  private
    def tokens
      [
        [:KEY, "projects"],
        [:COLLECTION],
        [:KEY, "name"],
      ]
    end
  end

  class CLI
    def initialize(args=ARGV, io)
      @expression = args.first
      @io = io
    end

  private
    def tokenize(expression)
    end

    def parse(expression)
    end
  end
end
