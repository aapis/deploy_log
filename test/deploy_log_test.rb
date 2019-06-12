require "test_helper"

class DeployLogTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DeployLog::VERSION
  end

  describe '.merged_between' do
    let(:model) { DeployLog::Github::Deploys.new }
    let(:start) { '2019-06-11' }
    let(:finish) { '2019-06-12' }
    let(:title) { 'Better Tests' }
    let(:branch) { 'my_branch' }

    it 'finds PRs in the timeframe' do
      ARGV.replace ['aapis/deploy_log']

      assert model.merged_between(start, finish)
    end

    it 'finds PRs in the timeframe' do
      ARGV.replace ['aapis/deploy_log']

      assert @model.pr_title(title)
    end

    it 'finds PRs in the timeframe' do
      ARGV.replace ['aapis/deploy_log']

      assert @model.pr_for_branch(branch)
    end

    it 'finds PRs in the timeframe' do
      ARGV.replace ['aapis/deploy_log']

      assert @model.merged_today
    end
  end
end
