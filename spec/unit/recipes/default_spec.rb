require 'spec_helper'

describe 'drush::default' do

  before do
    stub_command("php -m | grep 'Phar'").and_return(true)
    stub_command("stat /usr/local/bin/composer").and_return(true)
  end

  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new
    runner.converge(described_recipe)
  end

  it 'should include composer recipe' do
    expect(chef_run).to include_recipe('composer::install')
  end

  it 'should include drush install recipe' do
    expect(chef_run).to include_recipe('drush::composer')
  end

end