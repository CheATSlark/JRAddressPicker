//
//  AddressPickerContentCell.swift
//  23
//
//  Created by 焦瑞洁 on 2020/2/27.
//  Copyright © 2020 ddcx. All rights reserved.
//

import UIKit

class AddressPickerContentCell: UICollectionViewCell {

    typealias areaTapClosure = (_ cityName: String,_ subAreas: [TsvAddressModel]?) -> ()
    var areaTap: areaTapClosure?
    
    @IBOutlet weak var table: UITableView!
    var list: [TsvAddressModel] = []{
        didSet{
            table.reloadData()
        }
    }
    var seletedModel: TsvAddressModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        table.register(UINib.init(nibName: "AddressPickerContentTbCell", bundle: Bundle(for: AddressPickerContentCell.self)), forCellReuseIdentifier: "cell")
        let footerView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: 50)))
        footerView.backgroundColor = .white
        table.tableFooterView = footerView
    }

}

extension AddressPickerContentCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressPickerContentTbCell
        cell.selectionStyle = .none
        let model = list[indexPath.row]
        cell.areaLb.text = model.city_name
        if model.isSelected == true{
            cell.tickImage.isHidden = false
            cell.toLeftConstraint.constant = 40
            cell.areaLb.textColor = JAddressPickerMainColor
        }else{
            cell.tickImage.isHidden = true
            cell.toLeftConstraint.constant = 20
            cell.areaLb.textColor = JAPickerMTextBlackColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = list[indexPath.row]
        
        if let selectedAddress = seletedModel {
            if model.id == selectedAddress.id {
                return
            }
            selectedAddress.isSelected = false
        }
        model.isSelected = true
        seletedModel = model
//        tableView.reloadData()
 
        if areaTap != nil {
            areaTap!(model.city_name, model.subAddressModel)
        }
        
    }
}
