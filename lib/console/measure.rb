# Copyright, 2019, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Console
	class Measure
		def initialize(output, subject, total = 0)
			@output = output
			@subject = subject
			
			@start_time = Time.now
			
			@current = 0
			@total = total
		end
		
		def duration
			Time.now - @start_time
		end
		
		def progress
			@current.to_f / @total.to_f
		end
		
		def remaining
			@total - @current
		end
		
		def average_duration
			if @current > 0
				duration / @current
			end
		end
		
		def estimated_remaining_time
			if average_duration = self.average_duration
				average_duration * remaining
			end
		end
		
		def increment(amount = 1)
			@current += amount
			
			@output.info(@subject, self) {Event::Progress.new(@current, @total)}
			
			return self
		end
		
		def mark(*arguments)
			@output.info(@subject, *arguments)
		end
		
		def to_s
			if estimated_remaining_time = self.estimated_remaining_time
				"#{@current}/#{@total} completed in #{self.formatted_duration self.duration}, #{self.formatted_duration estimated_remaining_time} remaining."
			else
				"#{@current}/#{@total} completed, waiting for estimate..."
			end
		end
		
		private
		
		def formatted_duration(duration)
			if duration < 60.0
				return "#{duration.round(2)}s"
			end
			
			duration /= 60.0
			
			if duration < 60.0
				return "#{duration.round}m"
			end
			
			duration /= 60.0
			
			if duration < 60.0
				return "#{duration.round(1)}h"
			end
			
			duration /= 24.0
			
			return "#{duration.round(1)}d"
		end
	end
end
