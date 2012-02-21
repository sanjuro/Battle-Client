class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :prepare_for_mobile
  
  private
  
  MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]
  
  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device? == 'mobile'
    # request.format = :mobile
  end    
    
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      agent = request.headers["HTTP_USER_AGENT"].downcase
      MOBILE_BROWSERS.each do |m|
        return "mobile" if agent.match(m)
      end
    end
    return false
  end
  helper_method :mobile_device?
  
end