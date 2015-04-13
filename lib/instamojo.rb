require 'json'
require 'logger'
require 'forwardable'

require "instamojo/version"
require "instamojo/domain"
require "instamojo/client"

module Instamojo
  class ApiError < RuntimeError; end
    
  class << self
    attr_writer :logger
    extend Forwardable
    
    def_delegators :client, 
                   :api_key, :auth_token, :secret_salt,
                   :api_key=, :auth_token=, :secret_salt=
    
    def_delegators :client,
                   :debug, 
                   :links,
                   :link_details,
                   :link_create,
                   :link_edit,
                   :link_delete,
                   :payments,
                   :payment_details,
                   :valid_mac?
    
    def logger
      @logger ||= lambda {
        logger = Logger.new($stdout)
        logger.level = Logger::INFO
        logger
      }.call
    end
    
    def client
      @client ||= Instamojo::Client.new(
        :api_key    => ENV['IMOJO_API_KEY'],
        :auth_token => ENV['IMOJO_AUTH_TOKEN'] 
      )
    end
    
  end
end
