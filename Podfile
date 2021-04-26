# Uncomment the next line to define a global platform for your project
 platform :ios, '13.7'

target 'technicalexam' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # RxSwift & Extensions
  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'RxOptional'
  pod 'RxKingfisher'
  
  # Utilites
  pod 'SwiftLint'
  
  # Network
  pod 'Moya'
  pod 'ObjectMapper'
  pod 'Moya/RxSwift'
  
  # Depency Injection
  pod 'Swinject', '~> 2.7'
  pod 'SwinjectAutoregistration', '~> 2.7'
  
  # UI Libraries
  pod 'Kingfisher'
  pod 'SnapKit'
  pod 'Hero'

  target 'technicalexamTests' do
    inherit! :search_paths
      pod 'Quick'
      pod 'RxTest'
      pod 'Nimble'
      pod 'RxBlocking'
      pod 'RxNimble'
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
   end
  end
end
