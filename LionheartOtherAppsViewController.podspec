# vim: ft=ruby

Pod::Spec.new do |s|
  s.name             = 'LionheartOtherAppsViewController'
  s.version          =  "2.0.0"
  s.summary          = 'A table view controller used to showcase your other apps.'
  s.homepage         = 'https://github.com/lionheart/LionheartOtherAppsViewController'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Dan Loewenherz' => 'dan@lionheartsw.com' }
  s.source           = { :git => 'https://github.com/lionheart/LionheartOtherAppsViewController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lionheartsw'

  s.ios.deployment_target = '10.3'

  s.source_files = 'LionheartOtherAppsViewController/Classes/**/*'

  s.dependency 'QuickTableView', '~> 3.0'
  s.dependency 'SuperLayout', '~> 2.0'

  s.swift_version = "4.2"
end
