Pod::Spec.new do |s|
  s.name             = 'Pegasus'
  s.version          = '2.0.0'
  s.summary          = 'Transition Manager'
  s.homepage         = 'https://github.com/efremidze/Pegasus'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'efremidze' => 'efremidzel@hotmail.com' }
  s.source           = { :git => 'https://github.com/efremidze/Pegasus.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/*.swift'
end
