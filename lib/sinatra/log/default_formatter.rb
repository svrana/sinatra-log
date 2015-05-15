require 'time'
require 'log4r'

module Sinatra
  class Log
    # Formatter that include the filename and relative path, and line number in
    # output of the caller.
    #
    # Since all callers go through the methods defined in this class to log, we
    # look at the second line of the tracer output, removing everything but the
    # directories after the project directory.
    class DefaultFormatter < Log4r::Formatter
      attr_reader :basedir

      # @param [String] basedir   The base project directory; this directory
      #   will be filtered out from each log entry if specified.
      def initialize(basedir = nil)
        super
        @basedir = basedir
      end

      # Return a trimmed version of the filename from where a LogEvent occurred
      #
      # @param [String] tracer A line from the LogEvent#tracer Array
      # @return [String] Trimmed and parsed version of the file ane line number
      def event_filename(tracer)
        if basedir.nil?
          parts = tracer.match(/(.*:[0-9]+).*:/)
        else
          parts = tracer.match(/#{basedir}\/(.*:[0-9]+).*:/)
        end

        # If we get no matches back, we're probably in a jar file in which case
        # the format of the tracer is going to be abbreviated
        if parts.nil?
          parts = tracer.match(/(.*:[0-9]+).*:/)
        end
        return parts[-1] if parts
      end

      # Receive the LogEvent and pull out the log message and format it for
      # display in the logs
      #
      # @param [Log4r::LogEvent] event
      # @return [String] Formatted log message
      def format(event)
        filename = event_filename(event.tracer[1])
        time = Time.now.utc.iso8601
        return "#{Log4r::LNAMES[event.level]}: #{time}: #{filename}: #{event.data}\n"
      end
    end
  end
end
