Pod::Spec.new do |s|

  s.license      = "MIT"
  s.author       = { "qqc" => "20599378@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc  = true

  s.name         = "QqcUtility"
  s.version      = "1.0.10"
  s.summary      = "QqcUtility"
  s.homepage     = "https://github.com/xukiki/QqcUtility"
  s.source       = { :git => "https://github.com/xukiki/QqcUtility.git", :tag => "#{s.version}" }
  
  s.source_files  = ["QqcUtility/*.{h,m}"]
  s.dependency = "QqcReachability"
  s.dependency = "NSString+Qqc"
  s.dependency = "QqcLog"

end
