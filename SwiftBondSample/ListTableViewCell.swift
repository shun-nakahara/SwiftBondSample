//
//  ListTableViewCell.swift
//  SwiftBondSample
//
//  Created by NakaharaShun on 10/31/15.
//  Copyright © 2015 NakaharaShun. All rights reserved.
//

import UIKit
import Bond

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        bnd_bag.dispose()
    }

    deinit {
        
    }
}
