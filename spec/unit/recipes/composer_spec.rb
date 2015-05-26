require 'spec_helper'

describe 'drush::composer' do

  before do
    stub_command("php -m | grep 'Phar'").and_return(true)
    stub_command("stat /usr/local/bin/composer").and_return(true)
  end

  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new
    runner.converge(described_recipe)
  end

  it 'should install drush composer package' do
    expect(chef_run).to run_execute('install-drush-composer').with(
      cwd: '/nonexistent',
      command: '/usr/local/bin/composer global require drush/drush:7.* --no-interaction --no-ansi',
      environment: {'COMPOSER_HOME' => '/nonexistent', 'HOME' => '/nonexistent', 'USER' => 'nobody'},
      user: 'nobody'
    )
  end

  it 'should add drush path to bashrc' do
    expect(chef_run).to run_ruby_block('ensure composer bin dir is in PATH')
  end

end

# TODO: test unitario sobre llamadas dentro del block, con mocks de rspec
#
#   let(:editable) do
#    double(:insert_line_if_no_match => nil)
#   end
#
#   allow(Chef::Util::FileEdit).to receive(:new).with('/nonexistent/.bashrc').and_return(editable)
#   expect(editable).to receive(:insert_line_if_no_match)
#
# ruby_block  do
#   block do
#     fe = Chef::Util::FileEdit.new("#{::Dir.home(node['drush']['user'])}/.bashrc")
#     fe.insert_line_if_no_match(/$HOME\/vendor\/bin/, 'export PATH="$PATH:$HOME/vendor/bin"')
#     fe.write_file
#   end
#   action :run
# end

