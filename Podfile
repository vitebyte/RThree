# Uncomment this line to define a global platform for your project
#initial commit
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
# ignore all warnings from all pods
inhibit_all_warnings!
# Uncomment this line if you're using Swift
use_frameworks!

target 'DigitalEcoSystem' do
    #SnapKit
    pod 'SnapKit', '~> 4.0.0'
    # Network
    pod 'Reachability', '~> 3.2'
    pod 'Alamofire'
    
    # Fabric/Crashlytics
    pod 'Fabric'
    pod 'Crashlytics'
    
    # Analytics
    #pod 'Mixpanel'
    
    # Parsing
    pod 'SwiftyJSON'
    pod 'ObjectMapper'
    
    # Loader
    pod 'SVProgressHUD'
    pod 'SDWebImage'
    pod 'SVPullToRefresh'

    # Video Player
    pod 'HandyFrame' , '1.1.2'
    pod 'CTVideoPlayerView' , '1.3.1'
    
    # Localization
    pod 'Localize-Swift', '~> 1.7'
    
    # Pop Over
    pod 'Popover'

    # Log Manager
    pod 'XCGLogger', '~> 5.0.1'    
    # DataBase
    # pod 'RealmSwift' #, :git => 'https://github.com/realm/realm-cocoa.git', :branch => 'master'
    # pod 'CoreStore' # git => https://github.com/JohnEstropia/CoreStore#local-store
    pod 'CoreStore', '3.1.0'
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
