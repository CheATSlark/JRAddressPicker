//
//  AddressConfig.swift
//  23
//
//  Created by 焦瑞洁 on 2020/8/5.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation
import UIKit
/// #F6F7F9
let JAddressTitleBgColor = pColor(color: 0xF6F7F9)

let JAddressPickerMainColor = pColor(color: 0xFF4C95)

let JAPickerMTextBlackColor = pColor(color: 0x222222)
let JAPickerMTextLightColor = pColor(color: 0x999999)


private func pColor(color: Int)->UIColor {
    
    let redComponent = ((color & 0xFF0000) >> 16)
    let greenComponent = ((color & 0x00FF00) >> 8)
    let blueComponent = (color & 0x0000FF)
    
    return UIColor.init(red: CGFloat.init(Float.init(redComponent) / 255.0), green: CGFloat.init(Float.init(greenComponent) / 255.0), blue: CGFloat.init(Float.init(blueComponent) / 255.0), alpha: 1.0)
}

func JAPickerTextWidth(textStr: String, font: UIFont, height: CGFloat) -> CGFloat{
    let normalText: NSString = textStr as NSString
    let size = CGSize(width: 1000, height:height)
    let attriuteDic: [NSAttributedString.Key : Any] = [ .font : font]
    let stringSize =  normalText.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attriuteDic, context: nil).size
    return stringSize.width
}

func BundleImage(name: String) -> UIImage? {
    let bundle = Bundle(for: AddressPicker.self)
    if let url = bundle.url(forResource: "JRAddressPicker", withExtension: "bundle"){
        let targetBundle = Bundle(url: url)
        return  UIImage(named: name, in: targetBundle, compatibleWith: nil)
    }
    return UIImage(named: name)
}
