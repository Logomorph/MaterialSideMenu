#
# Be sure to run `pod lib lint MaterialSideMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MaterialSideMenu'
  s.version          = '0.1.0'
  s.summary          = 'A Google Material design style side menu'

  #s.description      = <<-DESC
  #A Google Material design style side menu
  #                    DESC

  s.homepage         = 'https://github.com/Logomorph/MaterialSideMenu'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'logomorph' => 'logomorph@gmail.com' }
  s.source           = { :git => 'https://github.com/Logomorph/MaterialSideMenu.git', :branch => 'master', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'MaterialSideMenu/*.{h,m,swift}'
  s.swift_versions = '5.0'
end
