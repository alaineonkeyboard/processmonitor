class Schedule

	def self.get_schedules
		schedule_lines = `crontab -l`.split("\n")
		schedule_hash = Array.new

		schedule_lines.each do |line| 
			line_items = line.split(" ",6) # split each process line to column item and store them as hash objects

			schedule_hash << {
				minute: line_items[0],
				hour: line_items[1],
				day: line_items[2],
				month: line_items[3],
				day_of_week: line_items[4],
				command: line_items[5]
			}
		end

		return schedule_hash

	end

end