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
  it "runs with correct, system exit error" do
    expect { run_rake_task }.to raise_error(SystemExit)
  end
end