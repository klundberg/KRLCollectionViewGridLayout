
Pod::Spec.new do |s|
  s.name             = "KRLCollectionViewGridLayout"
  s.version          = "1.0.0"
  s.summary          = "A layout that specifies item size and location by number of columns."
  s.description      = <<-DESC
                       This layout is an alternative to UICollectionViewFlowLayout that positions and sizes items using a defined number of columns and an aspect ratio property. By default, this will always show the same number of items in a row no matter how large or small the collection view is.
                       DESC
  s.homepage         = "http://github.com/klundberg/KRLCollectionViewGridLayout"
  s.license          = 'MIT'
  s.author           = { "Kevin Lundberg" => "kevinrlundberg@gmail.com" }
  s.source           = { :git => "http://github.com/klundberg/KRLCollectionViewGridLayout.git", :tag => "1.0.0" }
#  s.social_media_url = 'https://twitter.com/EXAMPLE'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes'
end
