# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2022, by Samuel Williams.

require 'console/compatible/logger'

RSpec.describe Console::Compatible::Logger do
	let(:io) {StringIO.new}
	let(:output) {Console::Terminal::Logger.new(io)}
	let(:logger) {Console::Compatible::Logger.new("Test", output)}
	
	it "should log messages" do
		logger.info("Hello World")
		
		expect(io.string).to include("Hello World")
	end
	
	it "formats lower case severity string" do
		expect(logger.format_severity(1)).to be == :info
	end
end
