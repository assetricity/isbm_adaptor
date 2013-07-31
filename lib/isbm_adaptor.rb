require 'active_support/core_ext/object/blank'
require 'isbm_adaptor/version'
require 'savon'

module IsbmAdaptor
  autoload :ChannelManagement, 'isbm_adaptor/channel_management'
  autoload :ProviderPublication, 'isbm_adaptor/provider_publication'
  autoload :ConsumerPublication, 'isbm_adaptor/consumer_publication'
  autoload :Duration, 'isbm_adaptor/duration'
end
