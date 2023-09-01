class IssueService
  class Outcome
    attr_reader :model

    def initialize(success, model = nil)
      @success = success
      @model = model
    end

    def success?
      @success
    end
  end

  class << self
    def publish(params)
      issue = Issue.new(params.require(:issue).permit(:title, :banner_content, :initial_update_content).merge(status: Issue.statuses[:draft]))
      if issue.valid?
        issue.status = "active"
        issue.save!
        issue.issue_updates.create!(content: issue.initial_update_content)
        Outcome.new(true, issue)
      else
        Outcome.new(false, issue)
      end
    end

    def update(params)
      update = IssueUpdate.new(params.require(:issue_update).permit(:content).merge(issue_id: params[:id]))
      if update.valid?
        update.save!
        Outcome.new(true, update)
      else
        Outcome.new(false, update)
      end
    end

    def resolve(params)
      update = IssueUpdate.new(params.require(:issue_update).permit(:content).merge(issue_id: params[:id]))
      if update.valid?
        update.save!
        update.issue.update!(status: Issue.statuses[:resolved])
        Outcome.new(true, update)
      else
        Outcome.new(false, update)
      end
    end
  end
end
