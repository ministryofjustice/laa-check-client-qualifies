# frozen_string_literal: true

module CheckAnswers
  Table = Data.define(:screen, :index, :disputed?, :fields, :skip_change_link)
end
