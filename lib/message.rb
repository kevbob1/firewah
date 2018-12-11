class Message


  attr_accessor :message_type
  attr_accessor :body

  def initialize(message_type, body=nil)
    @message_type = message_type
    @body = body
  end
end