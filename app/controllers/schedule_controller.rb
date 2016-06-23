class ScheduleController < ApplicationController
  # GET
  def index
    @schedules = Schedule.get_schedules
  end

  def create
  	redirect_to schedule_index_path
  end

end
