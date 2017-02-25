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

        collectionView?.register(HeaderFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerFooterIdentifier)
        collectionView?.register(HeaderFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: headerFooterIdentifier)
    }

    @IBAction func changeColumnsTapped(_ sender: AnyObject?) {
        let alert = UIAlertController(title: "Choose how many columns", message: nil, preferredStyle: .actionSheet)

        for num in 1...6 {
            alert.addAction(UIAlertAction(title: num.description, style: .default, handler: { action in
                self.layout.numberOfItemsPerLine = num
            }))
        }

        present(alert, animated: true, completion: nil)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
    
        // Configure the cell
        if indexPath.section % 2 == 1 {
            cell.contentView.backgroundColor = .blue
        } else {
            cell.contentView.backgroundColor = .red
        }
  
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerFooterIdentifier, for: indexPath as IndexPath) as! HeaderFooterView

        view.label.text = kind
        return view
    }

}

extension GridLayoutCollectionViewController: KRLCollectionViewDelegateGridLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = CGFloat((section + 1) * 10)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat((section + 1) * 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, lineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat((section + 1) * 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceLengthForHeaderInSection section: Int) -> CGFloat {
        return CGFloat((section + 1) * 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceLengthForFooterInSection section: Int) -> CGFloat {
        return CGFloat((section + 1) * 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberItemsPerLineForSectionAt section: Int) -> Int {
        return self.layout.numberOfItemsPerLine + (section * 1)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, aspectRatioForItemsInSectionAt section: Int) -> CGFloat {
        return CGFloat(1 + section)
    }
}
