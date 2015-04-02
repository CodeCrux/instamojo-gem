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
                   :api_key, :api_token,
                   :api_key=, :api_token=
    
    def_delegators :client,
                   :debug, 
                   :links,
                   :link_details,
                   :link_create,
                   :link_edit,
                   :link_delete,
                   :payments,
                   :payment_details
    
    def logger
      @logger ||= lambda {
        logger = Logger.new($stdout)
        logger.level = Logger::INFO
        logger
      }.call
    end
    
    def client
      @client ||= Instamojo::Client.new(
        :api_key   => ENV['IMOJO_API_KEY'],
        :api_token => ENV['IMOJO_API_TOKEN'] 
      )
    end
    
  end
end
