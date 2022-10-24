class BaseCfeService
  def cfe_connection
    @cfe_connection ||= CfeConnection.connection
  end
end
