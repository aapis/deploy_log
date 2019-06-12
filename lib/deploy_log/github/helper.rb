# frozen_string_literal: true

require 'octokit'
require 'fileutils'

module DeployLog
  module Github
    class Helper
      attr_accessor :force

      LINE_FORMAT = "%s (%s)\n - Created by %s\n - Branch: %s\n - Merged by %s on %s\n - Changes: %s\n -- %s\n\n"

      def initialize(user_repo, force)
        @client = ::Octokit::Client.new(login: ENV['GITHUB_USER'], password: ENV['GITHUB_TOKEN'])
        @repo_location = user_repo
        @force = force
        puts force.inspect
      end

      def pulls_in_timeframe(date_start = nil, date_end = nil)
        cache = cache_file(date_start, date_end)
        return cache[:contents] if should_show_cache(cache)

        @client.auto_paginate = true
        list = @client.pull_requests(@repo_location,
          state: :closed,
          per_page: 500,
          sort: 'long-running'
        )

        prs_covered = 0

        File.open(cache[:path], 'w+') do |f|
          list.each do |pr|
            next unless (date_start..date_end).cover? pr.merged_at

            prs_covered += 1

            f.write(
              sprintf(
                LINE_FORMAT,
                pr.title,
                pr.html_url,
                pr.user.login,
                pr.head.ref,
                user_who_merged(pr.number),
                formatted_time(pr.merged_at, true),
                pr.diff_url,
                committers_for(pr.number).join("\n -- ")
              )
            )
          end

          f.write("============================================================\n#{prs_covered} PR(s) merged from #{date_start} to #{date_end}\n============================================================\n")
        end

        return ::Notify.warning("No pull requests have been merged in the requested date range (#{date_start} - #{date_end})") if prs_covered.zero?

        system('cat /tmp/github-deploys.log')
      end

      def search_pulls_by(value, field = :title)
        cache = cache_file(value, field)
        return cache[:contents] if should_show_cache(cache)

        list = @client.pull_requests(@repo_location,
          :state => :all,
          :per_page => 100
          )
        prs_covered = 0

        File.open(cache[:path], 'w+') do |f|
          list.each do |pr|
            next unless nested_hash_value(pr, field).match?(/#{value}\b/)

            prs_covered += 1

            f.write(
              sprintf(
                LINE_FORMAT,
                pr.title,
                pr.html_url,
                pr.user.login,
                pr.head.ref,
                user_who_merged(pr.number),
                formatted_time(pr.merged_at, true),
                pr.diff_url,
                committers_for(pr.number).join("\n -- ")
              )
            )
          end

          f.write("============================================================\n#{prs_covered} PR(s) matched\n============================================================\n")
        end

        return ::Notify.warning("No pull requests match the requested term (#{value})") if prs_covered.zero?

        system('cat /tmp/github-deploys.log')
      end

      private

      def user_who_merged(num)
        pr = @client.pull_request(@repo_location, num)
        pr.merged_by.login
      end

      def committers_for(num)
        commits = @client.pull_request_commits(@repo_location, num)
        commits.map do |c|
          "#{c.author.login} committed '#{c.commit.message}' at #{formatted_time(c.commit.committer.date, true)}"
        end
      end

      def cache_file(*args)
        hash = Digest::MD5.hexdigest(@repo_location + args.join('|'))
        path = FileUtils.touch "/tmp/github-deploys-#{hash}.log"

        {
          contents: system("cat #{path.first}"),
          path: path.first
        }
      end

      def should_show_cache(cache)
        return false if @force

        File.exist?(cache[:path]) && !File.size(cache[:path]).zero?
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
