require 'packer-cli'
require 'test/unit'

ENV['RACK_ENV'] = 'test'

class PackerCLITest < Test::Unit::TestCase
  def setup
    @uri = '/myrepo'
    @sha = 'mysha'
    @name = 'name'
    @dest = '/my/dir'
    @test_opts = ['-u', @uri, '-s', @sha, '-n', @name, '-d', @dest]
  end

  def test_argument_handling
    assert_nothing_raised do
      cli = Packer::CLI.new(@test_opts)
      assert_equal(@uri, cli.opts[:uri])
      assert_equal(@sha, cli.opts[:sha])
      assert_equal(@name, cli.opts[:name])
      assert_equal(@dest, cli.opts[:dest])
    end
  end

  def test_empty_arguments
    Trollop.expects(:die).at_least_once
    cli = Packer::CLI.new
    assert_equal(cli.class, Packer::CLI)
  end

  def test_run
    test_tar_file = "/tmp/test.tar"
    FileUtils.expects(:mv).once
    Packer::Processor.any_instance.expects(:fetch).with(@uri, @sha).returns(Packer::Processor.new(@name))
    Packer::Processor.any_instance.expects(:build).returns(Packer::Processor.new(@name))
    test = Packer::Processor.any_instance.stubs(:mktar).returns(test_tar_file)
    Packer::CLI.any_instance.expects(:puts).once
    cli = Packer::CLI.new(@test_opts)
    cli.run
  end
end
