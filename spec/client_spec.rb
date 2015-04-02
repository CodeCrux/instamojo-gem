require 'spec_helper'

describe Instamojo::Client do
  
  let(:client) { Instamojo::Client.new('abc', '123') }
  
  it { expect(client.api_key).to eq('abc') }
  it { expect(client.api_token).to eq('123') }
  
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
  
end

