# CrocodocException extends the default exception class.
# It adds a code field.
class CrocodocError < Exception
  # An error code string
  @code = nil
  
  # Get the error code
  def code
    @code
  end

  def initialize(message, code)
    @message = message
    @code = code
  end
end
