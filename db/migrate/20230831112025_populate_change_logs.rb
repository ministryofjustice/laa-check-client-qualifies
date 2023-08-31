class PopulateChangeLogs < ActiveRecord::Migration[7.0]
  def up
    ChangeLog.create!(
      title: "Public beta",
      released_on: "2023-8-22",
      published: true,
      content: trix_format(
        "<p class=\"govuk-body\">This service was launched as a public beta, available to all users. Until this date it was in a private pilot phase, available only by invitation.</p>",
      ),
    )
    ChangeLog.create!(
      title: "Changes for clients aged under 18",
      released_on: "2023-8-3",
      tag: "mtr",
      published: true,
      content: trix_format(
        "<p class=\"govuk-body\">From 3 August 2023, clients aged under 18 will not need a means assessment for certificated work matters or controlled legal representation (CLR) matters. For all other types of controlled work and family mediation matters, clients under 18 must have a full means assessment if any of the following apply:</p>
        <ul class=\"govuk-list govuk-list--bullet\"><li>their means are aggregated with another person’s, like a parent or guardian</li><li>they get regular income, like payment from a job</li><li>they have capital worth more than £2,500</li></ul>",
      ),
    )
    ChangeLog.create!(
      title: "Self-employed clients",
      released_on: "2023-7-25",
      published: true,
      content: trix_format(
        "<p class=\"govuk-body\">This service now supports clients (and their partners) who are self-employed, with the exception of self-employed company directors for certificated checks.</p>",
      ),
    )
    ChangeLog.create!(
      title: "Controlled work forms",
      released_on: "2023-7-10",
      published: true,
      content: trix_format(
        "<p class=\"govuk-body\">When a controlled work check is completed, this service will add the results to a downloadable PDF for the civil controlled work forms that collect a client’s financial information:</p>
        <ul class=\"govuk-list govuk-list--bullet\"><li>CW1: financial eligibility for legal aid clients</li><li>CW1&amp;2MH: legal help and controlled legal representation (mental health)</li><li>CW2IMM: controlled legal representation (Immigration)</li><li>CW5: financial eligibility form for clients wanting family mediation</li><li>CIVMEANS7: financial assessment for family mediation</li></ul>",
      ),
    )
    ChangeLog.create!(
      title: "Guidance for clients in specific circumstances",
      released_on: "2023-6-15",
      published: true,
      content: trix_format(
        "<p class=\"govuk-body\">Additional guidance added to support clients in specific circumstances:</p>
        <ul class=\"govuk-list govuk-list--bullet\"><li>prisoners, police officers, members of HM Forces, clients who are bankrupt and clients who live outside the UK</li><li>clarification on when the finances of applicants under 18 are assessed</li></ul>",
      ),
    )
    ChangeLog.create!(
      title: "Changes to simplify the question flow for clients who have a partner",
      released_on: "2023-6-6",
      published: true,
      content: trix_format(
        "<ul class=\"govuk-list govuk-list--bullet\"><li>introduction of household questions (for dependants, housing costs, property and vehicles)</li></ul>",
      ),
    )
    ChangeLog.create!(
      title: "Changes to dependant and partner allowance",
      released_on: "2023-4-10",
      published: true,
      content: trix_format(
        "<p class=\"govuk-body\">Changes to dependant and partner allowances:</p>
        <ul class=\"govuk-list govuk-list--bullet\"><li>partner allowance increased to £211.32 (was £191.41)</li><li>dependant allowance increased to £338.90 (was £307.64)</li></ul>",
      ),
    )
  end

  def trix_format(string)
    "<div class=\"trix-content\">#{string}</div>".html_safe
  end

  def down
    ChangeLog.destroy_all
  end
end
