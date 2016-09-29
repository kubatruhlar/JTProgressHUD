Pod::Spec.new do |s|
  s.name         = "JTProgressHUD"
  s.version      = "1.0.5"
  s.summary      = "**JTProgressHUD** is the new **HUD** designed to show **YOUR** views in the **HUD style** **with one line of code**."

  s.description  = <<-DESC
                   **JTProgressHUD** is the new **HUD** designed to show **YOUR** views (eg. UIImageView animations) in the **HUD style** **with one line of code**.
                   DESC

  s.homepage     = "https://github.com/kubatruhlar/JTProgressHUD"
  s.screenshots  = "https://raw.githubusercontent.com/kubatruhlar/JTProgressHUD/master/Screens/preview.png"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author    = "Jakub Truhlar"
  s.social_media_url   = "http://kubatruhlar.cz"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/kubatruhlar/JTProgressHUD.git", :tag => "1.0.5" }
  s.source_files  = "JTProgressHUD/*"
  s.framework  = "UIKit"
  s.requires_arc = true
end
