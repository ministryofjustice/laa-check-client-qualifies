module Strategy
  class FormHandlerStrategy
    def next_step session_data, step
      Steps::Helper.next_step_for(session_data, step)
    end
  end
end
