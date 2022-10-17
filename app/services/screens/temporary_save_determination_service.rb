# For the time being, we call CFE as we go along, although we are already working to change this
# Some of these CFE calls only occur based on knowledge of the screen flow, which we are
# now trying to bring into the internals of some Screen services
#
# So until we have eliminated as-we-go CFE calls, we need to provide them with temporary access to
# some knowledge about whether, based on internals of screen logic, we are in a situation that
# merits avoiding saving.
module Screens
  class TemporarySaveDeterminationService
    def self.call(estimate, current_screen_name)
      new.call(estimate, current_screen_name)
    end

    def call(estimate, current_screen_name)
      screens = ListerService.call(estimate)
      !avoid_saving?(screens, current_screen_name)
    end

    def avoid_saving?(screens, current_screen_name)
      current_step = screens.find { _1.name == current_screen_name }
      return false if current_step.check_answer_group.nil?

      current_index = screens.index(current_step)

      screens[(current_index + 1)..].any? { _1.check_answer_group == current_step.check_answer_group }
    end
  end
end
