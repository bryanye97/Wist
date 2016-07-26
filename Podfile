# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'Wist' do
  use_frameworks!
  pod "Koloda"
  pod 'Bond', '4.0.0'
  pod "ConvenienceKit"
  pod 'Parse'
  pod 'ParseFacebookUtilsV4'
  pod 'ParseUI'
  pod 'Firebase'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'JSQMessagesViewController', :git => 'https://github.com/jessesquires/JSQMessagesViewController.git', :branch => 'develop'
end

post_install do |installer|
  `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end