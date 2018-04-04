
# platform :osx, '10.9'
platform :ios, ‘8.1’
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!


target "OpticalValleyUnite" do

# U-Share SDK UI模块（分享面板，建议添加）
pod 'UMengUShare/UI'
# 集成微信(精简版0.2M)
pod 'UMengUShare/Social/ReducedWeChat'
# 集成QQ(精简版0.5M)
pod 'UMengUShare/Social/ReducedQQ'
# 集成新浪微博(精简版1M)
pod 'UMengUShare/Social/ReducedSina'
# 集成支付宝
pod 'UMengUShare/Social/AlipayShare'
# 集成豆瓣
pod 'UMengUShare/Social/Douban'
# 集成盯钉
pod 'UMCShare/Social/DingDing'
pod 'Alamofire’, '~> 4.5.0'
pod 'IQKeyboardManager', '~> 4.0.0'
pod 'Masonry', '~> 1.0.1'
pod 'SVProgressHUD'
pod 'RealmSwift', '~> 3.0.1'
pod 'MJRefresh'
pod 'Kingfisher', '~> 3.2.4'
pod 'LCNibBridge'
pod 'SnapKit', '~> 3.2.0'
pod 'KYDrawerController'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
    end
  end
end
