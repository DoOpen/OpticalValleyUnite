
# platform :osx, '10.9'
platform :ios, '8.1'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
target "OpticalValleyUnite" do

pod 'Alamofire'
#pod 'Kingfisher', '~> 3.2.4'
pod 'IQKeyboardManager', '~> 4.0.0'
pod 'Masonry', '~> 1.0.1'
pod 'SVProgressHUD'
pod 'RealmSwift', '~> 2.2.0'
pod 'MJRefresh'
pod 'Kingfisher', '~> 3.2.4'
pod 'LCNibBridge'
pod 'SnapKit', '~> 3.2.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
    end
  end
end
