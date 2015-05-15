require 'spec_helper'
require 'sinatra/log'

describe Sinatra::Log do
  let(:myconfig) do
    {
      :enabled => true,
      :logger_name => 'mylogger',
      :loglevel => 'DEBUG',
      :log_filename => 'rspec-test.log'
    }
  end

  subject(:log) { Sinatra::Log.new(myconfig) }
  subject(:log_message) { 'foo' }

  [:debug, :info, :warn, :error, :fatal].each do |method|
    describe ".#{method}" do
      it 'should invoke the internal logger object with a given block' do
        log.instance_variable_get(:@logger).should_receive(method).with(log_message).and_call_original
        processed = false
        b = Proc.new { processed = true }
        log.send(method, log_message, &b)
        expect(processed).to be(true)
      end

      it 'should invoke the internal logger object w/o a given block' do
        log.instance_variable_get(:@logger).should_receive(method).with(log_message).and_call_original
        log.send(method, log_message)
      end
    end
  end

  [:debug?, :info?, :warn?, :error?, :fatal?].each do |method|
    describe ".#{method}" do
      it 'returns true when level is debug' do
        expect(log.send(method)).to eq(true)
      end
    end
  end
end
