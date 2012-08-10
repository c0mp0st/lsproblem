require 'test/unit'
require 'mocha'
require 'packer'

class PackerLibTest < Test::Unit::TestCase
  attr_accessor :packer

  def setup
    @packer = Packer::Processor.new "test"
  end

  def teardown
    @packer.cleanup
  end

  def test_instantiation_and_cleanup
    assert_equal "test", packer.appname
    assert Dir.exists?(packer.tmpdir), "No tmpdir: #{packer.tmpdir}"
    assert_equal "test", packer.builddir
    packer.cleanup
    assert ! Dir.exists?(packer.tmpdir), "No tmpdir: #{packer.tmpdir}"
  end

  def test_fetch
    src = 'git://test.test/test.git'
    dst = packer.buildpath
    sha = 'blah'
    repo = mock()
    repo.expects(:checkout).with(sha).once
    Git.expects(:clone).with(src, dst).returns(repo).once
    packer.fetch src, sha
  end

  def test_build
    packer.expects(:run_bundle_install_deployment).returns(0)
    Dir.mkdir packer.buildpath
    env = ENV.to_hash
    packer.build
    assert_equal env, ENV.to_hash
  end

  def test_mktar
    Dir.mkdir packer.buildpath
    file = packer.mktar
    file_path = "#{packer.tmpdir}/#{file}"
    assert File.exists?(file_path), "No tar file #{file_path}"
  end
end
