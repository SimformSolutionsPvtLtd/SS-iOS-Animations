Pod::Spec.new do |s|
  s.name             = 'SSSwiftUIAnimations'
  s.version          = '1.0.0'
  s.summary          = 'With this library, you can make your app more fun and engaging by adding smooth and eye-catching animations to your app.'
  s.description      = <<-DESC
    SS-iOS-Animations: Turn ordinary user interfaces into extraordinary experiences! With this library, you can make your app more fun and engaging by adding smooth and eye-catching animations to your app. Whether you're new to SwiftUI or a pro, our easy-to-use animations make it simple to add that extra wow factor to your app. Spice up your app with cool transitions, fun effects, and interactive touches, all thanks to SS-iOS-Animations. Try it out and take your SwiftUI apps to the next level!
                        DESC
  s.homepage         = 'https://github.com/SimformSolutionsPvtLtd/SS-iOS-Animations.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rahul Yadav' => 'rahul.y@simformsolutions.com' }
  s.source           = { :git => 'https://github.com/SimformSolutionsPvtLtd/SS-iOS-Animations.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'SSSwiftUIAnimations/Sources/**/*'
  
  s.subspec 'WaterProgressAnimation' do |waterprogressanimation|
    waterprogressanimation.source_files = 'SSSwiftUIAnimations/Sources/WaterProgressAnimation/**/*', 'SSSwiftUIAnimations/Sources/Utils/**/*'
    end
    
  s.subspec 'ProgressAnimation' do |progressanimation|
        progressanimation.source_files = 'SSSwiftUIAnimations/Sources/ProgressAnimation/**/*',
            'SSSwiftUIAnimations/Sources/Utils/**/*'
        end
        
  s.subspec 'ArrowLeftRightAnimation' do |arrowleftrightanimation|
            arrowleftrightanimation.source_files = 'SSSwiftUIAnimations/Sources/ArrowLeftRightAnimation/**/*', 'SSSwiftUIAnimations/Sources/Utils/**/*'
        end
end
