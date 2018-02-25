require 'rails_helper'

describe "rake game:play", type: :task do
  let :run_rake_task do
    task.reenable
    task.execute
  end
	before do
    allow(STDIN).to receive_message_chain(:gets, :strip) { "1" }
    allow($stdout).to receive(:write)
	end
  it "runs without errors" do
    expect { run_rake_task }.to raise_error(SystemExit)
  end
  it "calls player move method" do
    expect_any_instance_of(Player).to receive(:move)
    run_rake_task
  end
end