#
#  Be sure to run `pod spec lint NicePermKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "NicePerformanceKit"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of NicePerformanceKit."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
  One toolkit aim to keep nice performance.
                   DESC

  spec.homepage     = "https://github.com/nirvana_icy/NicePerformanceKit/"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = "BSD"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "Nirvana.icy" => "jinglong.bi@me.com" }
  # Or just: spec.author    = "jinglong.bi@me.com"
  # spec.social_media_url   = "https://twitter.com/"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

#   spec.platform     = :ios
   spec.platform     = :ios, "10.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/nirvana_icy/NicePerformanceKit/.git", :tag => "#{spec.version}" }

  spec.default_subspec = 'Service'
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #
  spec.subspec 'Base' do |base|
    base.public_header_files = 'NicePerformanceKit/Classes/Base/**/*.h'
    base.source_files  = "NicePerformanceKit/Classes/Base/**/*.{h,m,mm}"
  end

  spec.subspec 'View' do |view|
    view.public_header_files = 'NicePerformanceKit/Classes/View/**/*.h'
    view.source_files  = "NicePerformanceKit/Classes/View/*.{h,m,mm}"
  end

  spec.subspec 'Service' do |service|
    service.subspec 'LaunchEngine' do |launch_engine|
      launch_engine.dependency 'NicePerformanceKit/Base'
      launch_engine.dependency 'NicePerformanceKit/View'
      launch_engine.public_header_files = 'NicePerformanceKit/Classes/Service/LaunchEngine/**/*.h'
      launch_engine.source_files  = "NicePerformanceKit/Classes/Service/LaunchEngine/**/*.{h,m,mm}"
    end
    service.subspec 'MetricKitReport' do |metric_kit_report|
      metric_kit_report.dependency 'NicePerformanceKit/Base'
      metric_kit_report.public_header_files = 'NicePerformanceKit/Classes/Service/MetricKitReport/**/*.h'
      metric_kit_report.source_files  = "NicePerformanceKit/Classes/Service/MetricKitReport/**/*.{h,m,mm}"
    end
    service.subspec 'PerfMonitor' do |perf_monitor|
      perf_monitor.dependency 'NicePerformanceKit/Base'
      perf_monitor.dependency 'NicePerformanceKit/View'
      perf_monitor.public_header_files = 'NicePerformanceKit/Classes/Service/PerfMonitor/**/*.h'
      perf_monitor.source_files  = "NicePerformanceKit/Classes/Service/PerfMonitor/**/*.{h,m,mm}"
    end
  end

  spec.subspec 'Tool' do |tool|
    tool.subspec 'TimeProfile' do |time_profile|
      time_profile.dependency 'NicePerformanceKit/Base'
      time_profile.public_header_files = 'NicePerformanceKit/Classes/Tool/TimeProfile/**/*.h'
      time_profile.source_files  = "NicePerformanceKit/Classes/Tool/TimeProfile/**/*.{h,m,mm}"
    end
    
    tool.subspec 'Image' do |image|
      image.public_header_files = 'NicePerformanceKit/Classes/Tool/Image/**/*.h'
      image.source_files  = "NicePerformanceKit/Classes/Tool/Image/**/*.{h,m,mm}"
    end
  end

  spec.subspec 'TestCase' do |test_case|
    test_case.public_header_files = 'NicePerformanceKit/Classes/TestCase/**/*.h'
    test_case.source_files  = "NicePerformanceKit/Classes/TestCase/**/*.{h,m,mm}"
  end
  
  # spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  spec.frameworks = "CoreServices", "ImageIO"

   spec.library   = "c++"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
