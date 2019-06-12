# frozen_string_literal: true

require 'deploy_log/version'
require 'deploy_log/github/helper'
require 'deploy_log/github/deploys'

module DeployLog
  class Error < StandardError; end
end
