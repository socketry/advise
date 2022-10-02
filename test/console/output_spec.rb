# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021, by Samuel Williams.

require 'console/logger'
require 'console/capture'

class MyCustomOutput
	def initialize(output, **options)
	end
end

RSpec.describe Console::Output do
	describe '.new' do
		context 'when output to $stderr' do
			it 'should set the default to Terminal::Logger' do
				allow($stderr).to receive(:tty?).and_return(true)
				expect(Console::Output.new($stderr)).to be_a Console::Terminal::Logger
			end
		end
		
		it 'can set output to Serialized and format to JSON by ENV' do
			output = Console::Output.new(StringIO.new, {'CONSOLE_OUTPUT' => 'JSON'})
			
			expect(output).to be_a Console::Serialized::Logger
			expect(output.format).to be == JSON
		end
		
		it 'can set output to Serialized using custom format by ENV' do
			output = Console::Output.new(StringIO.new, {'CONSOLE_OUTPUT' => 'MyCustomOutput'})
			
			expect(output).to be_a MyCustomOutput
		end
		
		it 'raises error until the given format class is available' do
			expect {
				Console::Output.new(nil, {'CONSOLE_OUTPUT' => 'InvalidOutput'})
			}.to raise_error(NameError, /Console::Output::InvalidOutput/)
		end
		
		it 'can force format to XTerm for non tty output by ENV' do
			io = StringIO.new
			expect(Console::Terminal).not_to receive(:for).with(io)
			output = Console::Output.new(io, {'CONSOLE_OUTPUT' => 'XTerm'})
			expect(output).to be_a Console::Terminal::Logger
			expect(output.terminal).to be_a Console::Terminal::XTerm
		end
		
		it 'can force format to text for tty output by ENV using Text' do
			io = StringIO.new
			expect(Console::Terminal).not_to receive(:for).with(io)
			output = Console::Output.new(io, {'CONSOLE_OUTPUT' => 'Text'})
			expect(output).to be_a Console::Terminal::Logger
			expect(output.terminal).to be_a Console::Terminal::Text
		end
	end
end
