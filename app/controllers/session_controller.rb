class SessionController < ApplicationController
  DUMMY_DATA = {
    "string" => "foo",
    "integer" => 1,
    "float" => 1.23,
    "decimal" => 1.23.to_d,
  }.freeze

  def populate
    session["standard"] = DUMMY_DATA
    session["json"] = DUMMY_DATA.to_json
    session["xml"] = DUMMY_DATA.to_xml
    render plain: "Session populated"
  end

  def show
    standard = session["standard"]
    json = JSON.parse(session["json"])
    xml = Hash.from_trusted_xml(session["xml"])["hash"]
    render inline: "standard:<br/> #{standard}<br/> json: <br/>#{json}<br/> xml: <br/> #{xml}"
  end
end
