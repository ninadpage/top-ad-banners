module Enumerable
  def pluck(key)
    map {|obj| obj[key] }
  end
end
