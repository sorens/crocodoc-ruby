# CrocodocError extends the default exception class.
# It adds a code field.
class CrocodocError < StandardError

  attr_accessor :code

  def initialize(message, code)
    self.code = code
    super message
  end
end
