Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "Payleven-mPos"
  s.version      = "1.2.1"
  s.summary      = "Payleven mPos SDK"

  s.description  = <<-DESC
                   iOS API to communicate with the payleven Chip & PIN card reader in order to accept debit and credit card payments. Learn more about the Chip & PIN card reader and payment options on one of payleven's regional websites.
                   DESC

  s.homepage     = "https://payleven.de/developers/"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  
  s.author             = { "Payleven" => "developer@payleven.com" }

  s.platform     = :ios
  s.platform     = :ios, "7.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/payleven/Point-Pay-SDK-iOS.git", :tag => "1.2.1" }

  s.vendored_frameworks = "Framework/AdyenToolkit.framework", "Framework/PaylevenSDK.framework"
  s.resources = "Framework/AdyenToolkit.bundle"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

	s.frameworks = "CoreData", "CoreLocation", "ExternalAccessory", "SystemConfiguration"
	s.library = "sqlite3.0"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.
  s.vendored_frameworks = "Framework/AdyenToolkit.framework", "Framework/PaylevenSDK.framework"
  s.frameworks = "CoreData", "CoreLocation", "ExternalAccessory", "SystemConfiguration"
  s.library = "sqlite3.0"


end
