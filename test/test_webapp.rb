require 'webapp'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class PackerWebTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Packer::WebApp
  end

  def test_it_says_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Please use a post request instead', last_response.body
  end
end
