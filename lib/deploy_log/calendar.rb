# frozen_string_literal = true

module DeployLog
  class Calendar
    def week(week_num)
      year_calendar(2019).to_a[week_num]
    end

    private

    def range_for(year)
      start = Date.parse("#{year}-01-01")
      finish = Date.parse("#{year}-12-31")

      (start..finish)
    end

    def year_calendar(year)
      date_range = range_for(year)
      output = (1..52).to_a.map { |w| { w => [] } }

      date_range.each do |day|
        output[day.cweek] = {}
        output[day.cweek][:first] = (day - 7).to_time
        output[day.cweek][:last] = day.to_time + (24 * 60 * 60) - 1
      end

      output
    end
  end
end
