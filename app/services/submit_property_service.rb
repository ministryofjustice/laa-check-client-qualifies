class SubmitPropertyService < CfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    # binding.pry
    model = Flow::PropertyEntryHandler.model(cfe_session_data)
    # return if model.house_value.blank?

    main_home = {
      value: model.house_value,
      outstanding_mortgage: (model.mortgage.presence if cfe_session_data["property_owned"] == "with_mortgage") || 0,
      percentage_owned: model.percentage_owned,
    }
    cfe_connection.create_properties(cfe_estimate_id, main_home, nil)
  end
end
