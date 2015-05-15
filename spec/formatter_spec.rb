require 'spec_helper'
require 'sinatra/log/default_formatter'
require 'timecop'

describe Sinatra::Log::DefaultFormatter do
  let(:project_name) { 'some_project' }
  let(:basedir) { "/home/proj/backend/#{project_name}" }
  let(:logger) do
    logger = double('Mock Logger')
    logger.stub(:name).and_return('RSpec Logger')
    logger.stub(:fullname).and_return('RSpec Logger')
    logger
  end
  let(:tracer) do
    [
        "#{basedir}/log.rb:63:in `warn'",
        "#{basedir}/spec/log_spec.rb:9:in `block (2 levels) in <top (required)>'"
    ]
  end

  subject(:formatter) { described_class.new(basedir) }

  before :all do
    # The root logger creates the log levels, so making sure it's been
    # created
    Log4r::RootLogger.instance
  end

  describe '#event_filename' do
    subject(:filename) { formatter.event_filename(tracer[1]) }

    context 'with the project name specified' do
      context 'with a normal MRI LogEvent' do
        it { should eql('spec/log_spec.rb:9') }
      end
    end

    context 'without the project name specified' do
      let(:formatter) { described_class.new }

      it { should eql("#{basedir}/spec/log_spec.rb:9") }
    end

    # We have slightly different log formats under packaged .jar files
    context 'with a LogEvent from a packaged .jar' do
      let(:tracer) { [nil, "backend/metrics.rb:52:in `runloop'"] }
      let(:basedir) { 'file:/home/user/source/projects/stuff.jar!/project' }

      it { should eql('backend/metrics.rb:52') }
    end
  end

  describe '#format' do
    before :each do
      Timecop.freeze
    end

    after :each do
      Timecop.return
    end

    context 'with a valid LogEvent' do
      # Level 3 is the Log4r "warn" level
      let(:level) { 3 }
      let(:data) { 'rspec' }
      let(:timestamp) { Time.now.utc.iso8601 }
      let(:event) { Log4r::LogEvent.new(level, logger, tracer, data) }

      it 'should be properly formatted' do
        expect(formatter.format(event)).to eql("WARN: #{timestamp}: spec/log_spec.rb:9: #{data}\n")
      end
    end
  end
end
