Pod::Spec.new do |s|
  s.name             = 'LionheartOtherAppsViewController'
  s.version          = '0.1.0'
  s.summary          = 'A short description of LionheartOtherAppsViewController.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/dlo/LionheartOtherAppsViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dlo' => 'dan@lionheartsw.com' }
  s.source           = { :git => 'https://github.com/dlo/LionheartOtherAppsViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.3'

  s.source_files = 'LionheartOtherAppsViewController/Classes/**/*'
  s.dependency 'QuickTableView', '~> 2.3'
  s.dependency 'SDWebImage'

  # s.resource_bundles = {
  #   'LionheartOtherAppsViewController' => ['LionheartOtherAppsViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
