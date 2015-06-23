Pod::Spec.new do |s|
  s.name         = "JTProgressHUD"
  s.version      = "1.0.0"
  s.summary      = "**JTProgressHUD** is the new **HUD** designed to show **YOUR** views (eg. UIImageView animations) in the **HUD style** **with one line of code**."

  s.description  = <<-DESC
                   **JTProgressHUD** is the new **HUD** designed to show **YOUR** views (eg. UIImageView animations) in the **HUD style** **with one line of code**. You can see many HUDs with easy implementation, but **the idea** is that you want that **easy implementation** with **HUD style** (background that block views below so the user knows that something is processing), but want to **show YOUR** animations/views (could be your app’s animated logo). *By DEFAULT* one animation is also included/built-in.
                   DESC

  s.homepage     = "https://github.com/kubatru/JTProgressHUD"
  s.screenshots  = "https://raw.githubusercontent.com/kubatru/JTProgressHUD/master/Screens/preview.png"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author    = "Jakub Truhlar"
  s.social_media_url   = "http://kubatruhlar.cz"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/kubatru/JTProgressHUD.git", :tag => "1.0.0" }
  s.source_files  = "JTProgressHUD/*"
  s.framework  = "UIKit"
  s.requires_arc = true
end
