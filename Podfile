# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Cuisiner' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cuisiner

  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'
  pod 'Firebase/Storage'
  pod 'FirebaseFirestoreSwift', '~> 9.4'
  pod 'Kingfisher', '~> 7.6.2'
  pod 'lottie-ios'
  pod 'IQKeyboardManagerSwift', '6.3.0'
  
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end