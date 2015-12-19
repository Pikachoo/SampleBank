class Timemachine < ActiveRecord::Base
  self.table_name = 'timemachine'

  def self.get_current_date
    Timemachine.find(1).cur_date
  end

end
