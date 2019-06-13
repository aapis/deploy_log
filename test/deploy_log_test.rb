require "test_helper"

class DeployLogTest < Minitest::Test
  CLI_ARGS = ['aapis/deploy_log'].freeze

  describe 'something' do
    let(:model) { DeployLog::Github::Deploys.new }

    describe '.merged_between' do
      let(:start) { '2019-06-12' }
      let(:finish) { '2019-06-12' }

      it 'finds PRs in the timeframe' do
        ARGV.replace CLI_ARGS

        assert model.merged_between(start, finish)
      end
    end

    describe '.pr_title' do
      let(:title) { 'Better Tests' }

      it 'finds PR with the requested title' do
        ARGV.replace CLI_ARGS

        assert model.pr_title(title)
      end
    end

    describe '.pr_for_branch' do
      let(:branch) { 'my_branch' }

      it 'finds PR for the requested branch' do
        ARGV.replace CLI_ARGS

        assert model.pr_for_branch(branch)
      end
    end

    describe '.merged_today' do
      it 'finds PRs merged today' do
        ARGV.replace CLI_ARGS

        assert model.merged_today
      end
    end

    describe '.merged_during_week' do
      it 'finds PRs merged this week' do
        ARGV.replace CLI_ARGS

        assert model.merged_during_week(24)
      end
    end
  end
end
