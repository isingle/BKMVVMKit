#
# Be sure to run `pod lib lint BKMVVMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BKMVVMKit'
  s.version          = '0.3.2'
  s.summary          = 'A short description of BKMVVMKit.'
  s.description      = 'BKMVVMKit'
  s.homepage         = 'https://github.com/isingle/BKMMVMKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'isingle' => 'isingle@163.com' }
  s.platform         = :ios, "8.0"
  s.source           = { :git => 'https://github.com/isingle/LBKMMVMKit', :tag => s.name.to_s + "-" + s.version.to_s }

  s.preserve_paths = "#{s.name}/Classes/**/*", "#{s.name}/Assets/**/*", "#{s.name}/Framework/**/*", "#{s.name}/Archive/**/*", "#{s.name}/Dependencies/**/*", "#{s.name}/**/*.pch"
  #s.prefix_header_file = ''
 

  #//common pod
  s.source_files = "#{s.name}/Classes/**/*.{h,m,mm,c,cpp,cc}"
  s.public_header_files = "#{s.name}/Classes/**/*.h"
  #//
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
 
end
