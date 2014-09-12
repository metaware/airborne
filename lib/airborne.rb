require 'rest_client'
require 'json'
require 'request_expectations'

module AirBorne

	class Configuration
		attr_accessor :base_url
	end

	def self.configure
		config = Configuration.new
		yield config
		@@base_url = config.base_url
	end

	include RequestExpectations

	def get(url)
		@response = RestClient.get(@@base_url + url)
		@body = JSON.parse(@response.body)
		symbolize_keys_deep!(@body)
	end

	def post(url, body)
	end

	def response
		@response
	end

	def body
		@body
	end

	private

	def get_headers
	end
	
	def symbolize_keys_deep!(h)
		h.keys.each do |k|
			ks = k.to_sym
			h[ks] = h.delete k
			symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
		end
	end	
end

