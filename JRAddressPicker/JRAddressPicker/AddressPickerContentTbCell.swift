//
//  AddressPickerContentTbCell.swift
//  23
//
//  Created by 焦瑞洁 on 2020/2/27.
//  Copyright © 2020 ddcx. All rights reserved.
//

import UIKit

class AddressPickerContentTbCell: UITableViewCell {

    @IBOutlet weak var areaLb: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var toLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        tickImage.image = BundleImage(name: "address_picker_select")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
