require 'spec_helper'

describe Instamojo::Client do
  
  let(:client) { Instamojo::Client.new('abc', '123') }
  
  it { expect(client.api_key).to eq('abc') }
  it { expect(client.auth_token).to eq('123') }
  
  def resource_path path
    "/api/#{Instamojo.client.api_version}/#{path}/"  
  end
  
  it 'should returns all links' do
    links = [{'title' => 'link1'}, {'title' => 'link2'}]
  
    Excon.stub({:path => resource_path('links') }, {
      :body => { links: links, success: true }.to_json, :status => 200})
    
    response = client.links
    expect(response.size).to eq(2)

    expect(response[0].title).to eq('link1')
    expect(response[1].title).to eq('link2')
  end
  
  it 'shold fetch link details' do
    link = { title: 'test', description: 'test description', base_price: 10, currency: 'INR' }
    
    Excon.stub({:path => resource_path("links/test") }, { 
      :body => { link: link, success: true }.to_json, status: 200 })
    
    response = client.link_details('test')
    expect(response.title).to eq('test')
    expect(response.price).to eq(10)
  end
  
  it 'should create a link' do
    link = { title: 'test', description: 'test description', price: 10, currency: 'INR' }
    Excon.stub({:path => resource_path('links'), method: :post }, { 
      body: { link: link, success: true }.to_json, 
      :status => 200})
    
    response = client.link_create(link[:title], link[:description], link[:price], note: 'test note')
    
    expect(response.title).to eq('test')
  end
  
  it 'should list all payments' do
    payments = [{'payment_id' => 'p1'}, {'payment_id' => 'p2'}]
  
    Excon.stub({:path => resource_path('payments') }, {
      :body => { payments: payments, success: true }.to_json, :status => 200})
    
    response = client.payments
    expect(response.size).to eq(2)

    expect(response[0].payment_id).to eq('p1')
    expect(response[1].payment_id).to eq('p2')
  end
  

  it 'shold fetch payment details' do
    payment = { payment_id: 'p1' }
    
    Excon.stub({:path => resource_path("payments/p1") }, { 
      :body => { payment: payment, success: true }.to_json, status: 200 })
    
    response = client.payment_details('p1')
    expect(response.payment_id).to eq('p1')
  end
  
  describe 'valid_mac?', wip: true do
    context 'when invalid' do
      it 'should return false' do
        data = { :payment_id => 12132, :buyer => 'foo@bar.com', :amount => 100, mac: 'foobar' }
        expect(client.valid_mac?(data, 'abc')).to eq(false)
      end
    end

    context 'when valid' do
      it 'should return true' do
        data = { :payment_id => 1212, :buyer => 'foo@bar.com', 
                :amount => 100, mac: '61544dd438c58b9943302892ede4fcac815bd29f' }
                
        expect(client.valid_mac?(data, 'abc')).to eq(true) ## for testing only
      end
    end
      
    context 'with all webhook params' do
      it  'should return true' do
        data = Hash[{"buyer"=>"dinesh1042@gmail.com", "buyer_name"=>"dinesh", "quantity"=>"1", 
                "unit_price"=>"0.00", "status"=>"Credit", "fees"=>"0.00", "offer_slug"=>"test-62c75", 
                "amount"=>"0.00", "buyer_phone"=>"1234567891", "currency"=>"Free", 
                "payment_id"=>"MOJO5413000F58631508", "offer_title"=>"Test", "variants"=>"[]", 
                "custom_fields"=>"{}", "mac"=>"e7221033fb5b2ceaa8399b9d601a9d4aee279f6f" }.map{|k,v| [k.to_sym, v] }]
        
        expect(client.valid_mac?(data, 'abcdef')).to eq(true)
        
      end
    end
     
  end
end

