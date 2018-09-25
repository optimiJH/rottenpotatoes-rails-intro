class Movie < ActiveRecord::Base
  def self.all_ratings
    a = Array.new
    self.select("rating").unique.each {|x| a.push(x.rating)}
    a.sort.unique
  end
end
