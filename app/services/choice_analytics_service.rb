class ChoiceAnalyticsService
  def self.call(form, assessment_code, cookies)
    return if cookies[CookiesController::NO_ANALYTICS_MODE]

    browser_id = cookies[ApplicationController::BROWSER_ID_COOKIE]
    # For the most part, our analytics data should _only_ contain information
    # about the pages viewed by users, not the content of any forms they make.

    # This is because analytics events are keyed by the assessment_code, which
    # is in the URL so also in the application logs, so is stored alongside the
    # user's IP address. We don't in general want to store any more information
    # in our analytics data than is also available in the application logs.

    # There are rare and specific exceptions around choices that users make
    # that are (a) important to build meaningful metrics from our analytics data
    # and (b) not information that is in any way sensitive. This service
    # exists to create analytics data from those rare and specific choices
    case form
    when LevelOfHelpForm
      AnalyticsEvent.create!(
        event_type: "#{form.level_of_help}_level_of_help_chosen",
        page: :level_of_help_choice,
        assessment_code:,
        browser_id:,
      )
    end
  rescue StandardError => e
    ErrorService.call(e)
  end
end
