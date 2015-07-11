class Poles < ActiveRecord::Base
  before_save do 
    self.time = Time.now.to_i
  end
end
