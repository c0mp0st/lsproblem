require 'rubygems'
require 'sinatra'
require 'json'
require 'packer'

module Packer
  class WebApp < Sinatra::Base
    def self.get_args(params)
      push = JSON.parse(params[:payload])
      {
        :name => push["repository"]["name"],
        :uri  => push["repository"]["url"],
        :sha  => push["commits"].first["id"]
      }
    end

    post '/git-hook' do
      args = WebApp::get_args(params)
      dest = '/tmp'

      p = Packer::Processor.new(args[:name])
      begin
        tarfile = p.fetch(args[:uri], args[:sha]).build.mktar
        from = "#{p.tmpdir}/#{tarfile}"
        FileUtils.mv(from, dest)
      ensure
        p.cleanup
      end
    end
  end
end
