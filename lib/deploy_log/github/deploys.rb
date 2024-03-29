# frozen_string_literal: true

module DeployLog
  module Github
    class Deploys
      def initialize
        @github = Helper.new(ARGV.first)
      end

      def merged_between(start, finish = nil)
        return Notify.error 'Start (--start=) is a required argument' if start.nil?

        finish = Date.today.to_time + (24 * 60 * 60) - 1 if finish.nil?

        render @github.pulls_in_timeframe(start, finish)
      end

      def merged_today
        start = Date.today.to_time # 12:00AM this morning
        finish = Date.today.to_time + (24 * 60 * 60) - 1 # 11:59PM tonight

        render @github.pulls_in_timeframe(start, finish)
      end

      def merged_on(start)
        return Notify.error 'Start (--start=) is a required argument' if start.nil?

        finish = start + 24 * 60 * 60 - 1

        render @github.pulls_in_timeframe(start, finish)
      end

      def merged_during_week(week_num = nil)
        calendar = DeployLog::Calendar.new
        week = calendar.week(week_num.to_i)

        render @github.pulls_in_timeframe(week[:first], week[:last])
      end

      def pr_title(title)
        render @github.search_pulls_by(title, :title)
      end

      def pr_for_branch(branch)
        render @github.search_pulls_by(branch, :ref)
      end

      private

      def render(data)
        puts data if data.is_a? String
        data
      end
    end
  end
end
