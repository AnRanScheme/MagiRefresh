#
# Be sure to run `pod lib lint MagiRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MagiRefresh'
  s.version          = '0.0.8'
  s.summary          = 'Animated, customizable, and flexible pull-to-refresh framework for faster and easier iOS development. '
  s.swift_version    = '4.2'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Animated, customizable, and flexible pull-to-refresh framework for faster and easier iOS development.(Swift)
                       DESC

  s.homepage         = 'https://github.com/AnRanScheme/MagiRefresh'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AnRanScheme' => '541437674@qq.com' }
  s.source           = { :git => 'https://github.com/AnRanScheme/MagiRefresh.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MagiRefresh/Classes/**/*'
  
  s.resource_bundles = {
    'MagiRefresh' => ['MagiRefresh/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
