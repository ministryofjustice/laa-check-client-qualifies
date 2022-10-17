module Screens
  class NextScreenNameService
    def self.call(estimate, current_screen_name, in_check_answer_flow: false)
      new.call(estimate, current_screen_name, in_check_answer_flow)
    end

    def call(estimate, current_screen_name, in_check_answer_flow)
      screens = Screens::ListerService.call(estimate)

      if in_check_answer_flow && end_of_check_answer_loop?(screens, current_screen_name)
        :check_answers
      else
        next_step(screens, current_screen_name)
      end
    end

    def end_of_check_answer_loop?(screens, current_screen_name)
      current_step = screens.find { _1.name == current_screen_name }
      return true if current_step.check_answer_group.nil?

      current_index = screens.index(current_step)

      screens[(current_index + 1)..].none? { _1.check_answer_group == current_step.check_answer_group }
    end

    def next_step(screens, current_screen_name)
      screens.each_cons(2).detect { |screen, _successor| screen.name == current_screen_name }.last.name
    end
  end
end
