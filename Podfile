# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Brach-Nha-Khmer-Quiz-Game' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'BetterSegmentedControl', '~> 2.0'
  pod 'Google-Mobile-Ads-SDK'
  pod 'Hero'
  pod 'lottie-ios' 
  pod 'RealmSwift', '~> 10.43'
  pod 'UIImageViewAlignedSwift'

  
  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'GoogleSignIn'
  
  
  # Pods for Brach-Nha-Khmer-Quiz-Game
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
    end
    
    # Temporary fix for xcode 15 issue (await Cocaopod 1.13.0
    installer.aggregate_targets.each do |target|
      target.xcconfigs.each do |variant, xcconfig|
        xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
          xcconfig_path = config.base_configuration_reference.real_path
          IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
        end
      end
    end
  end

end
