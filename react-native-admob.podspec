require 'json'
package = JSON.parse(File.read(File.join(__dir__, './', 'package.json')))

Pod::Spec.new do |s|
  s.name          = package['name']
  s.version       = package['version']
  s.summary       = package['description']
  s.requires_arc  = true
  s.author        = package['author']
  s.license       = package['license']
  s.homepage      = package['homepage']
  s.source        = { :git => 'https://github.com/sbugert/react-native-admob.git', :tag => "v#{s.version}" }
  s.platform      = :ios, '7.0'
  s.source_files = "ios/*.{h,m,swift}"
  s.requires_arc = true
  s.dependency      'React'
  s.resource_bundles = { 
    'AdTemplates' => ['ios/*.xib'],
  }
  s.subspec 'AdmobSDK' do |ss|
    ss.dependency 'Google-Mobile-Ads-SDK'
  end
end