module Screens
  class PreviousScreenNameService
    def self.call(estimate, current_screen_name)
      new.call(estimate, current_screen_name)
    end

    def call(estimate, current_screen_name)
      screens = Screens::ListerService.call(estimate).reverse
      screens.each_cons(2).detect { |screen, _successor| screen.name == current_screen_name }.last.name
    end
  end
end
