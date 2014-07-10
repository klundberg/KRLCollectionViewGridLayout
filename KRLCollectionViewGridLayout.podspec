
Pod::Spec.new do |s|
  s.name             = "KRLCollectionViewGridLayout"
  s.version          = "0.1.1"
  s.summary          = "A UICollectionViewLayout that specifies item size and location by number of columns."
  s.description      = <<-DESC
                       This layout is an alternative to UICollectionViewFlowLayout that positions and sizes items using a defined number of columns and an aspect ratio property which force the size of cells, rather than the cells' size telling the layout how to lay them out. By default, this will always show the same number of items in a row no matter how large or small the collection view is.
                       DESC
  s.homepage         = "http://github.com/klundberg/KRLCollectionViewGridLayout"
  s.license          = 'MIT'
  s.author           = { "Kevin Lundberg" => "kevinrlundberg@gmail.com" }
  s.source           = { :git => "https://github.com/klundberg/KRLCollectionViewGridLayout.git", :tag => "v0.1.1" }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes'
end
