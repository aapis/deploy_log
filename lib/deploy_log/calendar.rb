# frozen_string_literal = true

module DeployLog
  class Calendar
    def start_of_week(week_num)
      # puts "THIS IS WEEK #{Date.today.cweek}"
      cal = year_calendar(2019).to_a#[Date.today.cweek]
      puts cal.inspect
      cal[:first]
    end

    private

    def range_for(year)
      start = Date.parse("#{year}-01-01")
      finish = Date.parse("#{year}-12-31")

      (start..finish)
    end

    def year_calendar(year)
      date_range = range_for(year)
      output = {}

      date_range.each do |day|
        output[day.cweek] = {}
        output[day.cweek][:first] = day
        # output[day.cweek][:last] = day
      end
      # puts output.inspect
      output
    end
  end
end
