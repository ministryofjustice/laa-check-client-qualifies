module Steps
  class Group
    def initialize(*steps)
      @steps = steps
    end

    attr_reader :steps
  end
end
