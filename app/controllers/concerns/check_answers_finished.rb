module CheckAnswersFinished
  extend ActiveSupport::Concern

  private

  def next_check_answer_step handler_classes, step, model, session_data
    steps = Enumerator.new do |yielder|
      next_step = step
      loop do
        next_step = StepsHelper.next_step_for(model, next_step)
        if next_step
          yielder << next_step
        else
          raise StopIteration
        end
      end
    end
    steps.drop_while { |step|  handler_classes.fetch(step).model(session_data).valid? }.first
  end
end
