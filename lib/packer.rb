require "packer/version"
require "tmpdir"
require "git"

# Processes a GIT URI and outputs a tarball
# * 'name' is used to name the tarball
# * 'uri' is the source GIT URI
# * 'commit' is the GIT commit
#
# Initialize a new processor:
#     p = Packer::Processor.new("name')
#
# Fetch a given git repository.  Optionally specify a commit (defaults
# to master):
#     p.fetch(uri, commit)
#
# Fetch all gem dependencies:
#     p.build
#
# Produce the tarball (returns tar filename):
#     p.mktar
#     => "filename"
#
# Clean up the temporary directory:
#     p.cleanup
#

module Packer
  class Processor
    attr_reader :appname, :tmpdir, :buildpath, :builddir

    def initialize(appname)
      @appname = appname
      @tmpdir = "#{Dir.tmpdir}/#{rand(2**128).to_s(36)}"
      Dir.mkdir(@tmpdir)
      @builddir = @appname
      @buildpath = "#{@tmpdir}/#{@builddir}"
    end

    def fetch(uri, commit = "master")
      @repo = Git.clone(uri, @buildpath)
      @repo.checkout(commit)
      self
    end

    def build
      Dir.chdir @buildpath do
        save_env = ENV.to_hash
        %w(BUNDLE_GEMFILE RUBYOPT BUNDLE_BIN_PATH).each do |e|
          ENV.delete(e)
        end
        run_bundle_install_deployment
        ENV.replace(save_env)
      end
      self
    end

    def mktar
      run_tar_cmd
    end

    def cleanup
      FileUtils.rm_rf(@tmpdir)
      nil
    end

    private
    def run_bundle_install_deployment
      `bundle install --deployment`
    end

    def run_tar_cmd
      options = "--exclude .git"
      tarfile = "#{@appname}.tar.gz"
      Dir.chdir @tmpdir do
        `tar zc #{options} -f #{tarfile} #{@builddir}`
      end
      tarfile
    end
  end
end
