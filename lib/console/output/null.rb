# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require_relative 'generic'

module Console
	module Output
		class Null < Generic
			def initialize(...)
			end
			
			def call(...)
				# Do nothing.
			end
		end
	end
end
