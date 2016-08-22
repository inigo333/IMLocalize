#
# Be sure to run `pod lib lint IMLocalize.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IMLocalize'
  s.version          = '0.1.0'
  s.summary          = 'Localize your apps with just a line of code. Easy to setup (again, just one line)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
IMLocalize is used for localization inside your app.
Import IMLocalize to appDelegate (or some other class before you actually want to localize a string for the first time): #import @IMLocalize;
Set it up by just writing: [[IMLocalizeManager shared] setup];
and then use it all over your app by just writing: IMLocalize(string_to_localize)
e.g: self.label.text = IMLocalize(string_to_localize);
DESC

  s.homepage         = 'https://github.com/inigo333/IMLocalize'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Inigo Mato' => 'inigo333@gmail.com' }
  s.source           = { :git => 'https://github.com/inigo333/IMLocalize.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/inigo333'

  s.ios.deployment_target = '8.0'

  s.source_files = 'IMLocalize/Classes/**/*'
  
  # s.resource_bundles = {
  #   'IMLocalize' => ['IMLocalize/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
