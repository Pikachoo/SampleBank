module Operator
  class TimemachineController < ApplicationController
    authorize_resource
    def new

      @cur_date = Timemachine.get_current_date
    end

    def create
      date = Timemachine.find_by(id: 1)
      if date
        date.update_attribute(:cur_date, params[:timemachine][:date])
      else
        date = Timemachine.create(cur_date: timemachine_params)
      end
      @cur_date = date.cur_date
    end
    private
    def timemachine_params
      params.require(:timemachine).permit(:date)
    end
  end
end

