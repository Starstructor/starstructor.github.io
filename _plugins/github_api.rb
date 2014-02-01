require 'net/http'
require 'openssl'
require 'json'

module Jekyll
  class GetTags < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super

      uri = URI('https://api.github.com/repos/Starstructor/starstructor/tags')

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new uri
        response = http.request request
        @json_obj = JSON.parse response.body
      end
    end

    def render(context)
      @json_obj.each do |tag|
        %|<li>Download #{tag['name']} (<a href='#{tag['zipball_url']}'>ZIP</a> \| <a href='#{tag['tarball_url']}'>TAR</a>)</li>|
      end
    end
  end
end

Liquid::Template.register_tag('get_tags', Jekyll::GetTags)