Pod::Spec.new do |s|
  s.name             = 'flutter_vnpt_ekyc_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin wrapping the VNPT eKYC native SDKs (Android & iOS).'
  s.description      = 'Flutter plugin wrapping the VNPT eKYC native SDKs (Android & iOS).'
  s.homepage         = 'https://ekyc.vnpt.vn'
  s.license          = { :type => 'Proprietary', :text => 'VNPT eKYC SDK binaries are proprietary to VNPT AI.' }
  s.author           = { 'Wikex' => 'dev@wikex.example' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.0'

  s.vendored_frameworks = 'Frameworks/ICSdkEKYC.xcframework', 'Frameworks/eKYCLib.xcframework'

  # The VNPT xcframeworks ship no arm64 simulator slice.
  s.pod_target_xcconfig  = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
