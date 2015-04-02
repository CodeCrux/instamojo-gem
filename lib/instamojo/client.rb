require 'excon'

module Instamojo
  class Client
    
    attr_accessor :api_key, :api_token, :api_url, :api_version
    
    CONFIG = {
      :api_url => 'https://www.instamojo.com/api',
      :api_version => '1.1',
      :api_headers => lambda { |api_key, api_token|
        user_agent = "instamojo-ruby, #{Instamojo::VERSION}"
        user_agent += ", #{RUBY_VERSION}, #{RUBY_PLATFORM}, #{RUBY_PATCHLEVEL}"
        if defined?(RUBY_ENGINE)
          user_agent += ", #{RUBY_ENGINE}"
        end
        { 
          "Content-Type"  => "application/json",
          "User-Agent"    => user_agent,
          "X-Api-Key"     => api_key,
          'X-Auth-Token'   => api_token
        }
      }
    }
    
    def initialize(*args)
      options = args[0]
      unless options.is_a?(Hash)
        options = { api_key: args[0], api_token: args[1] }.merge(args[2] || {})
      end
      
      self.api_key, self.api_token = options.values_at(:api_key, :api_token)

      self.api_url =  options[:api_url] || CONFIG[:api_url]
      self.api_version = options[:api_version] || CONFIG[:api_version]
      
      self.read_timeout = options[:read_timeout].to_f unless options[:read_timeout].nil?
    end
    
    def links
      response = api_call(:get, 'links')
      response['links'].map{|obj| Link.new(obj) }
    end

    def link_edit slug, options
      api_call(:patch, "links/#{slug}", options)
    end

    def link_details slug
      response = api_call(:get, "links/#{slug}")
      Link.new response['link']
    end
                
    def link_create title, description, price, options = {}
      options[:currency] ||= 'INR'
      options[:title]       = title
      options[:description] = description
      options[:base_price]  = price
      
      options[:file_upload_json] = upload_if_needed(options[:file])
      options[:cover_image_json] = upload_if_needed(options[:cover_image])
      
      response = api_call(:post, 'links', options)
      Link.new(response['link'])
    end
    
    def link_delete slug
      api_call(:delete, "links/#{slug}")
    end
    
    def payments
      api_call(:get, 'payments')['payments'].map do |obj|
        Payment.new obj
      end 
    end

    def payment_details payment_id
      response = api_call(:get, "payments/#{payment_id}")
      Payment.new response['payment']
    end    

    def file_upload_url
      api_call(:get, '/links/get_file_upload_url')['upload_url']
    end
    
    private
    
    def api_call method, path, params = {}
      uri = resource_path(path)
      
      Instamojo.logger.debug { 
        "[Instamojo API] #{method.upcase} #{uri} \n params: #{params} \n headers: #{headers}" 
      }
      
      request = case method
                when :get
                  Excon.get(uri, :headers => headers)
                when :post, :patch
                  Excon.post(uri, 
                      :body => params.to_json, 
                      :headers => headers)
                when :delete
                  Excon.delete(uri, headers: headers)
                end
      
      raise_error(request) if request.status >= 400
      
      if method == :delete
        request.status == 204
      else
        response = JSON.parse(request.body)
        raise_error(response) unless response['success']
        response
      end
    end
    
    def raise_error response
      case response
      when Hash
        raise ApiError, response['message']
      else
        raise ApiError, response.body || response.status
      end
    end
    
    def headers
      CONFIG[:api_headers].call(self.api_key, self.api_token)
    end
    
    def resource_path path
      [self.api_url, self.api_version.to_s, path].join('/') + '/'
    end
    
    def upload_if_needed filename
      File.open(filename) do |f|
        Excon.post(upload_url, :request_block => proc { f.read(Excon.defaults[:chunk_size]).to_s })
      end if filename      
    end
    
  end
end
