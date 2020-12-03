//
//  AddressPickerTitleCell.swift
//  23
//
//  Created by 焦瑞洁 on 2020/2/27.
//  Copyright © 2020 ddcx. All rights reserved.
//

import UIKit

class AddressPickerTitleCell: UICollectionViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var idicateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLb.textColor = JAPickerMTextLightColor
        idicateView.isHidden = true
        idicateView.backgroundColor  = JAddressPickerMainColor
        idicateView.layer.cornerRadius = 1.5
    }

}
