module ResultsHelper
  def header_with_hint(header_key, hint_key)
    (
      I18n.t(header_key) +
        tag.div(I18n.t(hint_key),
                class: "govuk-hint govuk-!-margin-top-1 govuk-!-margin-bottom-0")
    ).html_safe
  end
end
