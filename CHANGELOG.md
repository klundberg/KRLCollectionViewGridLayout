# KRLCollectionViewGridLayout CHANGELOG

## 0.2.0

* Added support for headers and footers, via the headerReferenceSize and footerReferenceSize properties.
 * Headers and footers behave similarly to UICollectionViewFlowLayout. In vertical mode, only the height of the reference size is considered. In horizontal mode, only the width is considered. Headers/footers are inset by the sectionInset, and are separated from the cells by the line spacing.

## 0.1.1

* Fixed a bug where horizontal scrolling layouts did not lay cells out correctly
* Fixed a bug where changing the size of the collection view did not properly invalidate the layout and force a recalculation of attribute frames.

## 0.1.0

Initial release.
