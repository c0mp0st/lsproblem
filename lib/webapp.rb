require 'rubygems'
require 'sinatra'
require 'json'
require 'packer'

module Packer
  class WebApp < Sinatra::Base
    get '/' do
      "Please use a post request instead"
    end

    post '/' do
      push = JSON.parse(params[:payload])
      name = push[:repository][:name]
      uri = push[:repository][:url]
      sha = push[:commits].first[:id]
      dest = Dir.pwd

      p = Packer::Processor.new(name)
      begin
        tarfile = p.fetch(uri, sha).build.mktar
        from = "#{p.tmpdir}/#{tarfile}"
        FileUtils.mv(from, dest)
      ensure
        p.cleanup
      end
    end
  end
end
