class BaseCfeService
  def self.call(cfe_connection, cfe_assessment_id, session_data)
    new(cfe_connection).call(cfe_assessment_id, session_data)
  end

  def initialize(cfe_connection)
    @cfe_connection = cfe_connection
  end

protected

  attr_reader :cfe_connection
end
