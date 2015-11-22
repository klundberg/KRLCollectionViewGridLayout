//  Copyright (c) 2015 Kevin Lundberg.

import UIKit
import KRLCollectionViewGridLayout

private let reuseIdentifier = "Cell"
private let headerFooterIdentifier = "headerFooter"

class GridLayoutCollectionViewController: UICollectionViewController {

    var layout: KRLCollectionViewGridLayout {
        return self.collectionView?.collectionViewLayout as! KRLCollectionViewGridLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView?.registerClass(HeaderFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerFooterIdentifier)
        collectionView?.registerClass(HeaderFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: headerFooterIdentifier)
    }

    @IBAction func changeColumnsTapped(sender: AnyObject?) {
        let alert = UIAlertController(title: "Choose how many columns", message: nil, preferredStyle: .ActionSheet)

        for num in 1...6 {
            alert.addAction(UIAlertAction(title: num.description, style: .Default, handler: { action in
                self.layout.numberOfItemsPerLine = num
            }))
        }

        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) 
    
        // Configure the cell
        if indexPath.section % 2 == 1 {
            cell.contentView.backgroundColor = UIColor.blueColor()
        } else {
            cell.contentView.backgroundColor = UIColor.redColor()
        }
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerFooterIdentifier, forIndexPath: indexPath) as! HeaderFooterView

        view.label.text = kind
        return view
    }

}

extension GridLayoutCollectionViewController: KRLCollectionViewDelegateGridLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let inset = CGFloat((section + 1) * 10)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, interitemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat((section + 1) * 10)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, lineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat((section + 1) * 10)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceLengthForHeaderInSection section: Int) -> CGFloat {
        return CGFloat((section + 1) * 20)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceLengthForFooterInSection section: Int) -> CGFloat {
        return CGFloat((section + 1) * 20)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberItemsPerLineForSectionAtIndex section: Int) -> Int {
        return self.layout.numberOfItemsPerLine + (section * 1)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, aspectRatioForItemsInSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(1 + section)
    }
}
