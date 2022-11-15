class BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def cfe_connection
    @cfe_connection ||= CfeConnection.connection
  end
end
