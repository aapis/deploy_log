# frozen_string_literal: true

require 'octokit'

module DeployLog
  module Github
    attr_reader :repo

    class Api
      def initialize(repo)
        @client = Octokit::Client.new(login: ENV['GITHUB_USER'], password: ENV['GITHUB_TOKEN'])
        @client.auto_paginate = true

        @repo = repo
      end

      def pull_requests(options = {})
        default_opts = {
          state: :closed,
          per_page: 500,
          sort: 'long-running'
        }

        begin
          @client.pull_requests(@repo, default_opts.merge(options))
        rescue Octokit::NotFound => e
          Notify.error e.message
        end
      end

      def pull_request(id)
        begin
          @client.pull_request(@repo, id)
        rescue Octokit::NotFound => e
          Notify.error e.message
        end
      end

      def commits_for(id)
        begin
          @client.pull_request_commits(@repo, id)
        rescue Octokit::NotFound => e
          Notify.error e.message
        end
      end
    end
  end
end