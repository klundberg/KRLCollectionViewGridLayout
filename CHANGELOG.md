# KRLCollectionViewGridLayout CHANGELOG

## 1.0.0
* Marked library as stable with a 1.0 release

## 0.4.1

* Reorganized repo and added framework iOS target
* Added tvOS as a supported platform along with tvOS framework target and (barebones) demo

## 0.4.0

* Added KRLCollectionViewDelegateGridLayout protocol with methods that control various metrics on a per-section basis, including:
 * aspect ratio
 * number of items per line
 * section inset
 * footer length
 * header length
 * line spacing
 * inter-item spacing
* Section insets now work more similarly to UICollectionViewFlowLayout. Before they were applying to the header/footer in addition to the items in a section. Now they only apply to the items, and the header/footer are always full width/height depending on scroll direction. 

## 0.3.1

* Removed some extraneous types that were not yet finished.

## 0.3.0

* Changed headerReferenceSize/footerReferenceSize (CGSize) properties to headerReferenceLength/footerReferenceLength (CGFloat) properties.
* Updated demo project to swift 1.2/Xcode 6.3.

## 0.2.0

* Added support for headers and footers, via the headerReferenceSize and footerReferenceSize properties.
 * Headers and footers behave similarly to UICollectionViewFlowLayout. In vertical mode, only the height of the reference size is considered. In horizontal mode, only the width is considered. 
 * Headers/footers are inset by the sectionInset, and are separated from the cells by the line spacing.

## 0.1.1

* Fixed a bug where horizontal scrolling layouts did not lay cells out correctly
* Fixed a bug where changing the size of the collection view did not properly invalidate the layout and force a recalculation of attribute frames.

## 0.1.0

Initial release.
