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

        @github.pulls_in_timeframe(start, finish)
      end

      def merged_today
        start = Date.today.to_time # 12:00AM this morning
        finish = Date.today.to_time + (24 * 60 * 60) - 1 # 11:59PM tonight

        @github.pulls_in_timeframe(start, finish)
      end

      def merged_on(start)
        return Notify.error 'Start (--start=) is a required argument' if start.nil?

        finish = start + 24 * 60 * 60 - 1

        @github.pulls_in_timeframe(start, finish)
      end

      def merged_during_week(week_num)
        return Notify.error 'Week number (--week|-w) is a required argument' if week_num.nil?

        start = DeployLog::Calendar.start_of_week(24)
        finish = start + 24 * 60 * 60 - 1

        @github.pulls_in_timeframe(start, finish)
      end

      def pr_title(title)
        @github.search_pulls_by(title, :title)
      end

      def pr_for_branch(branch)
        @github.search_pulls_by(branch, :ref)
      end
    end
  end
end
