require 'mail'
require 'postmark'
require_relative 'base.rb'

module MailHandler

  module Sending

    class PostmarkAPISender < Sender

      attr_accessor :host,
                    :api_token,
                    :use_ssl,
                    :client

      def initialize(api_token = nil)

        @type = :postmark_api
        @host = DEFAULT_HOST
        @api_token = api_token
        @use_ssl = false

      end

      def send(email)

        verify_email(email)
        init_client
        client.deliver_message(email)

      end

      def init_client

        @client = setup_sending_client

      end

      def setup_sending_client

        # clearing cache so valid host is accepted, and not the cached one
        Postmark::HttpClient.instance_variable_set('@http', nil)
        Postmark::ApiClient.new(api_token, http_open_timeout: 15, host: host, secure: @use_ssl)

      end

      protected

      DEFAULT_HOST = 'api.postmarkapp.com'

    end

  end

end
