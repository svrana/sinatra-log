require 'rubygems'
require 'log4r'
require 'sinatra/log/default_formatter'

module Sinatra
  # Logs to specified filename with the format:
  #
  #   [Log Level]: [Timestamp (ISO-8601)]: [File:linenum]: [Log Message]
  #
  class Log
    include Log4r

    attr_reader :outputter

    REQUIRED_CONFIG_SYMBOLS = [:logger_name, :loglevel, :log_filename,
                               :enabled].freeze

    def initialize(config={})
      errors = []
      REQUIRED_CONFIG_SYMBOLS.each do |key|
        if !config.include?(key)
          errors << "#{key} required, but not specified in config hash"
        end
      end
      raise ArgumentError, "#{errors}" if errors.count > 0

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
      @outputter.formatter = DefaultFormatter.new(config[:project_dir])
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
