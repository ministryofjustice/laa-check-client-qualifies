module Screens
  class NameListerService
    def self.call(estimate = nil)
      new.call(estimate)
    end

    def call(estimate)
      Screens::ListerService.call(estimate).map(&:name)
    end
  end
end
