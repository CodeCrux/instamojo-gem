require 'spec_helper'

describe Instamojo do
  it 'has a version number' do
    expect(Instamojo::VERSION).not_to be nil
  end

  it 'should set api_key' do
    Instamojo.api_key = 'abc'
    expect(Instamojo.api_key).to eq('abc')
  end

  it 'should set api_key' do
    Instamojo.api_token = 'abc'
    expect(Instamojo.api_token).to eq('abc')
  end
  
  it 'should have a client' do
    expect(Instamojo.client).to be_a(Instamojo::Client)    
  end
  
  
end
