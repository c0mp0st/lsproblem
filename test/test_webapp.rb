require 'webapp'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
SAMPLE_DATA = File.dirname(__FILE__) + "/data/sample_payload.json"

class PackerWebTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @json = File.read(SAMPLE_DATA)
    @params = { :payload => @json }
  end

  def app
    Packer::WebApp
  end

  def test_get_args
    args = ::Packer::WebApp::get_args(@params)
    assert_equal('github', args[:name])
    assert_equal('http://github.com/defunkt/github', args[:uri])
    assert_equal('41a212ee83ca127e3c8cf465891ab7216a705f59', args[:sha])
  end

  def test_post_git_hook
    args = ::Packer::WebApp::get_args(@params)
    test_tar_file = "/tmp/github.tar"
    FileUtils.expects(:mv).once
    Packer::Processor.any_instance.expects(:fetch).with(args[:uri], args[:sha]).returns(Packer::Processor.new(args[:name]))
    Packer::Processor.any_instance.expects(:build).returns(Packer::Processor.new(args[:name]))
    test = Packer::Processor.any_instance.stubs(:mktar).returns(test_tar_file)
    post '/git-hook', { :payload => @json }
    assert last_response.ok?
  end
end
