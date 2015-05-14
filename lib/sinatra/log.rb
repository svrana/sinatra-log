require 'rubygems'
require 'log4r'
require 'time'

module Sinatra
  # Logging.  Logs to log/<project_name>.log with the format:
  #
  #   [Log Level]: [Timestamp (ISO-8601)]: [File:linenum]: [Log Message]
  #
  # Use through the helper:
  #   log.warn 'This is my log message'
  #
  class Log
    include Log4r

    # Formatter that include the filename and relative path, and line number in
    # output of the caller.
    #
    # Since all callers go through the methods defined in this class to log, we
    # look at the second line of the tracer output, removing everything but the
    # directories after the project directory.
    #
    class DefaultFormatter < Log4r::Formatter
      # Return the project base directory for filtering to help with
      # identifiying the filename and line number when formatting the log
      # message
      #
      # @return [String] Base directory for the project
      def basedir
        @basedir ||= File.expand_path(File.join(File.dirname(__FILE__), ".."))
      end

      # Return a trimmed version of the filename from where a LogEvent occurred
      # @param [String] tracer A line from the LogEvent#tracer Array
      # @return [String] Trimmed and parsed version of the file ane line number
      def event_filename(tracer)
        parts = tracer.match(/#{basedir}\/(.*:[0-9]+).*:/)

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

    attr_reader :outputter

    def initialize(config={})
      errors = []
      [:logger_name, :loglevel, :log_filename, :enabled].each do |key|
        if !config.include?(key)
          errors << "#{key} required, but not specified in config hash"
        end
        raise ArgumentError, "#{errors}" if errors.count > 0
      end

      logger_name = config[:logger_name].to_s.gsub(/\s+/, '_')
      @logger = Log4r::Logger.new(logger_name)

      if config[:enabled]
        index = Log4r::LNAMES.index(config[:loglevel])
        # if logger.level is not in LNAMES an exception will be thrown
        @logger.level = index unless index.nil?
      else
        @logger.level = Log4r::OFF
      end

      @outputter = FileOutputter.new("#{logger_name}fileoutput",
                                     :filename => config[:log_filename],
                                     :trunc => false)
      @logger.trace = true
      @outputter.formatter = DefaultFormatter
      @logger.outputters = @outputter
    end


    [:debug, :info, :warn, :error, :fatal, :level].each do |method|
      define_method(method) do |*args, &block|
        @logger.send(method, *args, &block)
      end

      # Returns true iff the current severity level allows for
      # the printing of level messages.
      allow_logging = "#{method}?".to_sym
      define_method(allow_logging) do |*args|
        @logger.send(allow_logging, *args)
      end
    end
  end
end
