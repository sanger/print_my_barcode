class Array
  def to_h_derived
    Hash[self.collect { |v| [v,v]}]
  end
end