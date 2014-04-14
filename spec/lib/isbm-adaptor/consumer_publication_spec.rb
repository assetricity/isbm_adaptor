require 'spec_helper'

describe IsbmAdaptor::ConsumerPublication, :vcr do
  let(:client) { IsbmAdaptor::ConsumerPublication.new(ENDPOINTS['consumer_publication'], OPTIONS) }

  context 'with invalid arguments' do
    describe '#open_session' do
      let(:uri) { 'Test' }
      let(:topics) { ['topics'] }

      it 'raises error with no URI' do
        expect { client.open_session(nil, topics) }.to raise_error ArgumentError
      end

      it 'raises error with no topics' do
        expect { client.open_session(uri, nil) }.to raise_error ArgumentError
      end
    end

    describe '#read_publication' do
      it 'raises error with no session id' do
        expect { client.read_publication(nil, nil) }.to raise_error ArgumentError
      end
    end

    describe '#close_session' do
      it 'raises error with no session id' do
        expect { client.close_session(nil) }.to raise_error ArgumentError
      end
    end
  end

  context 'with valid arguments' do
    let(:uri) { 'Test' }
    let(:type) { :publication }
    let(:topics) { ['topic'] }
    let(:content) { File.read(File.expand_path(File.dirname(__FILE__)) + '/../../fixtures/ccom.xml') }
    let(:channel_client) { IsbmAdaptor::ChannelManagement.new(ENDPOINTS['channel_management'], OPTIONS) }
    before { channel_client.create_channel(uri, type) }

    let(:consumer_session_id) { client.open_session(uri, topics) }

    describe '#open_session' do
      it 'returns a session id' do
        consumer_session_id.should_not be_nil
      end
    end

    context 'with provider' do
      let(:provider_client) { IsbmAdaptor::ProviderPublication.new(ENDPOINTS['provider_publication'], OPTIONS) }
      let(:provider_session_id) { provider_client.open_session(uri) }

      describe '#read_publication' do
        before { provider_client.post_publication(provider_session_id, content, topics) }

        let(:message) { client.read_publication(consumer_session_id, nil) }

        it 'returns a valid message' do
          message.id.should_not be_nil
          message.topics.first.should == topics.first
          message.content.root.name.should == 'CCOMData'
        end

        let(:message2) { client.read_publication(consumer_session_id, message.id) }

        it 'returns nil when there are no more messages' do
          message2.should be_nil
        end
      end

      after { provider_client.close_session(provider_session_id) }
    end

    after do
      client.close_session(consumer_session_id)
      channel_client.delete_channel(uri)
    end
  end
end
