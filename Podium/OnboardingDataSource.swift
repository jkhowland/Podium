//
//  OnboardingDataSource.swift
//  Podium
//
//  Created by Ben Norris on 6/10/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit

class OnboardingDataSource: NSObject, UICollectionViewDataSource {
    
    let goalsCell = "goals"
    let invitesCell = "invites"
    let competitionCell = "competition"

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell? = nil
        switch indexPath.item {
        case 0:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(goalsCell, forIndexPath: indexPath)
        case 1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(invitesCell, forIndexPath: indexPath)
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(competitionCell, forIndexPath: indexPath)
        }
        return cell!
    }
}
