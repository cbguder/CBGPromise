Pod::Spec.new do |s|
  s.name         = "CBGPromise"
  s.version      = "0.3.1"
  s.summary      = "Simple promises in Swift, inspired by KSPromise"
  s.homepage     = "https://github.com/cbguder/CBGPromise"
  s.license      = "MIT"
  s.author       = { "Can Berk Güder" => "cbg@cbg.me" }
  s.source       = { :git => "https://github.com/cbguder/CBGPromise.git", :tag => "v0.3.1" }
  s.requires_arc = true

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"

  s.source_files = "CBGPromise/**/*.swift"
end
