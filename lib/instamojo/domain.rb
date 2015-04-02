
module Instamojo
  
  class Hashit
    attr_accessor :underlying
    
    def initialize(hash)
      @underlying = hash
      @underlying.each do |k,v|
        self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
        self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
        self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
      end
    end
    
    def to_s
      @underlying.to_s
    end        
    
  end
  
  class Link < Hashit
    def live?
      status == 'live'  
    end
    
    def self.find slug
      new Instamojo.client.link_details(slug)
    end
    
    def price
      self.base_price  
    end
    
  end
  
  class Payment < Hashit
    
    def paid?
      status == 'Credit'  
    end

    def self.find slug
      new Instamojo.client.payment_details(slug)
    end
    
  end
  
end