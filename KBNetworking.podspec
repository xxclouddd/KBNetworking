#
#  Be sure to run `pod spec lint KBFormSheetController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "KBNetworking"
  s.version      = "0.0.23"
  s.summary      = "KBNetworking."
  s.author       = {"xiaoxiong" => "821859554@qq.com"}
  s.description  = <<-DESC
                    This is KBNetworking.
                   DESC

  s.homepage     = "ssh://xxx/xxx/iOS/KBNetworking.git"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "xxx//xxx/iOS/KBNetworking.git", :tag => s.version.to_s }

  s.source_files  = "KBNetworking/KBNetworking/**/*.{h,m}"
  s.prefix_header_file = "KBNetworking/KBNetworking.pch"
  #s.frameworks = "CoreGraphics", "UIKit"
  s.requires_arc = true

  s.dependency "Categories"
  s.dependency "AFNetworking"
  s.dependency "RegexKitLite"
  s.dependency "KBUtils"

end
