# frozen_string_literal: true

require 'fileutils'

module DeployLog
  module Github
    class Helper
      LINE_FORMAT = "%s (%s)\n - Created by %s\n - Branch: %s\n - Merged by %s on %s\n - Changes: %s\n -- %s\n\n"

      def initialize(user_repo)
        @api = Api.new(user_repo)
        @cache = DeployLog::Cache.new('github-deploys-%s.log', repo: user_repo)
      end

      def pulls_in_timeframe(date_start, date_end)
        @cache.create(date_start, date_end)
        return @cache.contents if @cache.exists?

        pool = timeframe_pool(date_start, date_end)
        message = "#{pool.size} PR(s) merged from #{date_start} to #{date_end}"

        @cache.write_object(pool, message) do |item|
          format(LINE_FORMAT,
            item.title,
            item.html_url,
            item.user.login,
            item.head.ref,
            user_who_merged(item.number),
            formatted_time(item.merged_at, true),
            item.diff_url,
            committers_for(item.number).join("\n -- ")
          )
        end

        @cache.contents
      end

      def search_pulls_by(value, field = :title)
        @cache.create(field, value)
        return @cache.contents if @cache.exists?

        pool = search_pool(field, value)
        message = "#{pool.size} PR(s) matched"

        @cache.write_object(pool, message) do |item|
          format(LINE_FORMAT,
            item.title,
            item.html_url,
            item.user.login,
            item.head.ref,
            user_who_merged(item.number),
            formatted_time(item.merged_at, true),
            item.diff_url,
            committers_for(item.number).join("\n -- ")
          )
        end

        @cache.contents
      end

      private

      def timeframe_pool(date_start, date_end)
        pool = @api.pull_requests
        pool.select! { |pr| (date_start..date_end).cover?(pr.merged_at) }
        pool
      end

      def search_pool(field, value)
        pool = @api.pull_requests(state: :all, per_page: 100)
        pool.select! { |pr| nested_hash_value(pr, field).match?(/#{value}\b/) }
        pool
      end

      def user_who_merged(num)
        pr = @api.pull_request(num)
        pr.merged_by.login
      end

      def committers_for(num)
        commits = @api.commits_for(num)
        commits.map do |c|
          "#{c.author.login} committed '#{c.commit.message}' at #{formatted_time(c.commit.committer.date, true)}"
        end
      end

      def formatted_time(time, use_local_time = false)
        time = Time.now if time.nil?
        time = time.localtime if use_local_time

        fmt = '%e/%-m/%Y @ %I:%M:%S%P'
        fmt += ' UTC' unless use_local_time

        time.strftime(fmt)
      end

      def nested_hash_value(obj, key)
        if obj.respond_to?(:key?) && obj.key?(key)
          obj[key]
        elsif obj.respond_to?(:each)
          r = nil
          obj.find{ |*a| r=nested_hash_value(a.last,key) }
          r
        end
      end
    end
  end
end
