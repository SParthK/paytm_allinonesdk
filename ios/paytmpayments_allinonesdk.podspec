#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint paytmpayments_allinonesdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'paytmpayments_allinonesdk'
  s.version          = '1.0.2'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://www.paytmpayments.com/docs'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'PPSL' => 'integration.dev@paytmpayments.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.vendored_frameworks = 'Framework/AppInvokeSDK.xcframework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
