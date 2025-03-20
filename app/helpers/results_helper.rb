module ResultsHelper
  def header_with_hint(header_key, hint_key, hint_args: {})
    (
      I18n.t(header_key) +
        tag.div(I18n.t(hint_key, **hint_args),
                class: "govuk-hint govuk-!-margin-top-1 govuk-!-margin-bottom-0")
    ).html_safe
  end

  def header_with_two_hints(header_key, hint_key, hint_key_2, hint_args: {})
    (
      I18n.t(header_key) +
        tag.div(I18n.t(hint_key, **hint_args),
                class: "govuk-hint govuk-!-margin-top-1 govuk-!-margin-bottom-0") +
        tag.div(I18n.t(hint_key_2, **hint_args),
                class: "govuk-hint govuk-!-margin-top-1 govuk-!-margin-bottom-0")
    ).html_safe
  end

  def pdf_friendly_numeric_table_cell(row, value, bold_text: false)
    classes = bold_text ? "govuk-!-text-align-right govuk-!-font-weight-bold" : "govuk-!-text-align-right"
    row.with_cell(text: value, classes:)
  end

  def pdf_friendly_h1(text, is_pdf)
    if is_pdf
      tag.h2(class: "govuk-heading-l", style: "font-variant-ligatures: none;") do
        tag.ul(style: "list-style-type: none; margin: 0; padding: 0;") do
          tag.li(text)
        end
      end
    else
      tag.h1(text, class: "govuk-heading-l")
    end
  end

  def pdf_friendly_h2(text, size, is_pdf, additional_class = nil)
    if is_pdf
      tag.h2(class: "govuk-heading-#{size} #{additional_class}", style: "font-variant-ligatures: none;") do
        tag.ul(style: "list-style-type: none; margin: 0; padding: 0;") do
          tag.li(text)
        end
      end
    else
      tag.h2(text, class: "govuk-heading-#{size} #{additional_class}")
    end
  end

  def pdf_friendly_p_element(text, is_pdf, additional_class = nil)
    if is_pdf
      tag.ul(class: "govuk-list #{additional_class}", style: "list-style-type: none; margin: 0; padding-bottom: 10px; font-variant-ligatures: none;") do
        tag.li(text)
      end
    else
      tag.p(text, class: "govuk-body #{additional_class}")
    end
  end

  def pdf_friendly_paragraphs(text, is_pdf)
    if is_pdf
      modified_pdf_sentences = text.map do |sentence|
        tag.ul(class: "govuk-list", style: "list-style-type: none; margin: 0; padding-bottom: 5;") do
          tag.li(sentence)
        end
      end
      safe_join(modified_pdf_sentences)
    else
      modified_screen_sentences = text.map do |sentence|
        tag.p(sentence, class: "govuk-body")
      end
      safe_join(modified_screen_sentences)
    end
  end
end
