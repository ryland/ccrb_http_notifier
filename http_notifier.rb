require 'net/http'
require 'uri'

class HttpNotifier
  attr_accessor :extra_params, :use_basic_auth, :http_user, :http_password
  attr_reader :url
  
  def initialize(project = nil)
    @project = project
    @extra_params = {} 
    @use_basic_auth = false
  end

  def url=(url)
    @url = URI.parse(url)
  end

  def build_finished(build)
    return if @url.nil? or not build.failed?
    get(@url, :params => @extra_params.merge(:status => "#{build.project.name} build #{build.label} failed."))
  end

  def build_fixed(build, previous_build)
    return if @url.nil?
    get(@url, :params => @extra_params.merge(:status => "#{build.project.name} build #{build.label} fixed."))
  end
  
  private
  
  def get(url, opts)
    params = opts[:params].to_a.map { |x| "#{URI.escape(x.first.to_s)}=#{URI.escape(x.last)}" }.join("&")

    req = Net::HTTP::Get.new(@url.path+"?#{params}")
    req.basic_auth(@http_user, @http_password) if @use_basic_auth
    response = Net::HTTP.start(@url.host, @url.port) do |http|
      http.request(req)
    end
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
        CruiseControl::Log.event("Published HTTP notification to #{@url.to_s}.", :debug)
    else
        raise "Error publishing status. Body was [#{response.body}]"
    end
  rescue Exception => e
    CruiseControl::Log.event("Error publishing status: #{e}", :error)
  end

end

Project.plugin :http_notifier
