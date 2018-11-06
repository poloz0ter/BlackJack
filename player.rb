require_relative 'person'

class Player < Person
  attr_writer :name

  def initialize
    @name = nil
    super
  end

  def show_name
    name.to_s
  end
end
