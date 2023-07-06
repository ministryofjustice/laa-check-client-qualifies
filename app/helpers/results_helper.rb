module ResultsHelper
  def header_with_hint(header_key, hint_key, hint_args: {})
    (
      I18n.t(header_key) +
        tag.div(I18n.t(hint_key, **hint_args),
                class: "govuk-hint govuk-!-margin-top-1 govuk-!-margin-bottom-0")
    ).html_safe
  end

  def pdf_friendly_numeric_table_cell(row, value, bold_text: false)
    classes = bold_text ? "govuk-!-text-align-right govuk-!-font-weight-bold" : "govuk-!-text-align-right"
    row.with_cell(text: value, classes:)
  end
end
