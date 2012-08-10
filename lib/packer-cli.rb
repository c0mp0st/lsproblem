require 'packer'
require 'trollop'
require 'fileutils'

module Packer
  class CLI
    attr_reader :opts

    def initialize(args = ARGV)
      @opts = Trollop::options(args) do
        version "packer #{Packer::VERSION}"
        banner "Packer usage:\n"
        opt :uri, "Specify Git URI", :type => :string
        opt :sha, "SHA1 to check out", :type => :string
        opt :name, "Project name (used to name tarball)", :type => :string
        opt :dest, "Destination directory", :type => :string, :default => Dir.pwd
      end
    
      [:uri, :sha, :name].each do |param|
        Trollop::die param, "missing" unless @opts[param]
      end
    end

    def run
      p = Packer::Processor.new(@opts[:name])
      begin
        tarfile = p.fetch(@opts[:uri], @opts[:sha]).build.mktar
        from = "#{p.tmpdir}/#{tarfile}"
        FileUtils.mv(from, @opts[:dest])
        puts "Wrote #{@opts[:dest]}/#{tarfile}"
      ensure
        p.cleanup
      end
    end
  end
end
