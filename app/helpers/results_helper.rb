module ResultsHelper
  def header_with_hint(header_key, hint_key, hint_args: {})
    (
      I18n.t(header_key) +
        tag.div(I18n.t(hint_key, **hint_args),
                class: "govuk-hint govuk-!-margin-top-1 govuk-!-margin-bottom-0")
    ).html_safe
  end

  def pdf_friendly_h1(text, is_pdf)
    if is_pdf
      "<h2 class=\"govuk-heading-l\"><li>#{text}</li></h1>"
    else
      "<h1 class=\"govuk-heading-xl\">#{text}</h1>"
    end
  end

  def pdf_friendly_h2(text, size, is_pdf, additional_style, additional_class)
    if is_pdf
      "<h2 class=\"govuk-heading-#{size} #{additional_class}\" style=\"list-style-type: none; margin: 0; padding-bottom: 10; font-variant-ligatures: none; #{additional_style};\"><li>#{text}</li></h2>"
    else
      "<h2 class=\"govuk-heading-#{size} #{additional_class}\" style=\"#{additional_style}\">#{text}</h2>"
    end
  end

  def pdf_friendly_h3(text, size, is_pdf, additional_style, additional_class)
    if is_pdf
      "<h3 class=\"govuk-heading-#{size} #{additional_class}\" style=\"list-style-type: none; margin: 0; padding-bottom: 10; font-variant-ligatures: none; #{additional_style};\"><li>#{text}</li></h3>"
    else
      "<h3 class=\"govuk-heading-#{size} #{additional_class}\" style=\"#{additional_style}\">#{text}</h3>"
    end
  end

  def pdf_friendly_p_element(text, is_pdf, additional_class)
    if is_pdf
      "<ul class=\"govuk-list #{additional_class}\" style=\"list-style-type: none; margin: 0; padding-bottom: 10;\"><li>#{text}</li></ul>"
    else
      "<p class=\"govuk-body #{additional_class}\">#{text}</p>"
    end
  end

  def pdf_friendly_paragraphs(text, is_pdf)
    if is_pdf
      modified_pdf_sentences = text.map { |sentence| "<ul class=\"govuk-list\" style=\"list-style-type: none; margin: 0; padding-bottom: 5;\"><li>#{sentence}</li></ul>" }
      modified_pdf_sentences.join("")
    else
      modified_screen_sentences = text.map { |sentence| "<p class=\"govuk-body\">#{sentence}</p>" }
      modified_screen_sentences.join("")
    end
  end

  def pdf_friendly_logo(legal_aid, agency, is_pdf)
    if is_pdf
      "<span class=\"gem-c-organisation-logo__name\" style=\"list-style-type: none; margin: 0;\"><li>#{legal_aid}</li><li>#{agency}</li></span>"
    else
      "<span class=\"gem-c-organisation-logo__name\">#{legal_aid}<br>#{agency}</span>"
    end
  end

  def pdf_friendly_date(date, date_now, is_pdf)
    if is_pdf
      "<li style=\"list-style-type: none; margin: 0;\"><span class=\"govuk-body-m\">#{date}<strong> #{date_now}</strong></span></li>"
    else
      "<span class=\"govuk-body-m\">#{date}<strong> #{date_now}</strong><br></span>"
    end
  end
end
