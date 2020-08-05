//
//  ViewController.swift
//  JRAddressPicker
//
//  Created by 焦瑞洁 on 2020/8/5.
//  Copyright © 2020 焦瑞洁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func areasPickAction(_ sender: Any) {
        view.endEditing(true)
        AddressPicker.showPicker(view: UIApplication.shared.keyWindow!) { [unowned self](strArr) in
//            self.pickerArr = strArr
//            var result = ""
//            for (_, rst) in strArr.enumerated(){
//              result = result + rst
//            }
//            self.addressTF.text = result
        }
    }
    
}

