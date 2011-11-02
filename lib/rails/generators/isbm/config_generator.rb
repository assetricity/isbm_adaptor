# encoding: utf-8
module Isbm
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      desc "Creates an Isbm configuration file at config/isbm.yml"

      def self.source_root
        @_isbm_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def app_name
        Rails::Application.subclasses.first.parent.to_s.underscore
      end

      def create_config_file
        template 'isbm.yml', File.join('config', "isbm.yml")
      end

    end
  end
end

