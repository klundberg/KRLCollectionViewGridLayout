//
//  GridLayoutCollectionViewController.swift
//  KRLCollectionViewGridLayoutDemo
//
//  Created by Kevin Lundberg on 1/23/15.
//  Copyright (c) 2015 Lundbergsoft. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerFooterIdentifier = "headerFooter"

class GridLayoutCollectionViewController: UICollectionViewController {

    var layout: KRLCollectionViewGridLayout {
        return self.collectionView?.collectionViewLayout as KRLCollectionViewGridLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let nib = UINib(nibName: "HeaderFooterView", bundle: nil)
        collectionView?.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerFooterIdentifier)
        collectionView?.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: headerFooterIdentifier)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        // Configure the cell
        if indexPath.section % 2 == 1 {
            cell.contentView.backgroundColor = UIColor.blueColor()
        } else {
            cell.contentView.backgroundColor = UIColor.redColor()
        }
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerFooterIdentifier, forIndexPath: indexPath) as HeaderFooterView

        view.label.text = kind
        return view
    }

}
