//
//  AddressPicker.swift
//  23
//
//  Created by 焦瑞洁 on 2020/2/27.
//  Copyright © 2020 ddcx. All rights reserved.
//

import UIKit
import CSVImporter

open class AddressPicker: UIView {

    private var _didFinishPicking: (([String], Bool) -> Void)?
    public func didFinishPicking(completion: @escaping (_ items: [String], _ cancelled: Bool) -> Void) {
        _didFinishPicking = completion
    }
    private func didSelect(items: [String]) {
        _didFinishPicking?(items, false)
    }
    
    @IBOutlet weak var titlesCollection: UICollectionView!
    @IBOutlet weak var contentsCollection: UICollectionView!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    private var titlesArr = ["请选择"]
    private var titlesId = ["100000"]
    private var selectedTitleIndex = 0
    private var aresList: [TsvAddressModel] = []
    private var contentsList: [[TsvAddressModel]] = [[]]

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        titlesCollection.register(UINib.init(nibName: "AddressPickerTitleCell", bundle: Bundle(for: AddressPicker.self)), forCellWithReuseIdentifier: "titleCell")
        titlesCollection.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
        contentsCollection.register(UINib.init(nibName: "AddressPickerContentCell", bundle: Bundle(for: AddressPicker.self)), forCellWithReuseIdentifier: "contentCell")
        contentsCollection.isPagingEnabled = true
        getAreasList()
        contentsList = [aresList]
        
        closeBtn.setImage(BundleImage(name: "address_close"), for: .normal)
        titlesCollection.backgroundColor = JAddressTitleBgColor
        contentView.corner(byRoundingCorners: [.topLeft,.topRight], radii: 12,CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 210))
        contentView.clipsToBounds = true

    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    public static func showPicker(view: UIView,picked: @escaping([String])->Void) {
        let nib = UINib(nibName: "AddressPicker", bundle: Bundle(for: AddressPicker.self))
        let picker = nib.instantiate(withOwner: self, options: nil).first as? AddressPicker
//        let picker = Bundle.main.loadNibNamed("AddressPicker", owner: nil, options: nil)?.first as? AddressPicker
        if let pickerView = picker {
            picker?.frame = view.bounds
            view.addSubview(pickerView)
        }
        
        picker?.didFinishPicking(completion: { (resultStr, isFinish) in
            picked(resultStr)
        })
    }
    
    func getAreasList() {
        
        if let filepath = Bundle(for: AddressPicker.self).path(forResource: "address", ofType: "tsv") {
            
            let importer = CSVImporter<TsvAddressModel>(path: filepath)
            
            importer.startImportingRecords { recordValues -> TsvAddressModel in
                let values: [String] = recordValues[0].split(separator: "\t").compactMap { (item) -> String in
                    return "\(item)"
                }
                return TsvAddressModel(id: values[0], city_name: values[1], parent_id: values[2])
            }.onFinish { [unowned self]importedRecords in
                
                let recordsMutable = NSMutableArray.init(array: importedRecords)
                let areasArr = NSMutableArray.init(array: [])
                for  area in importedRecords {
                    
                    if area.parent_id == "100000" {
                        // 第一层
                        recordsMutable.remove(area)
                        areasArr.add(area)
                        
                        let subAreasArr = NSMutableArray.init(array: [])
                        let restArr: [TsvAddressModel] = recordsMutable as! [TsvAddressModel]
                        for subArea in restArr {
                            if subArea.parent_id == area.id {
                                // 第二层
                                recordsMutable.remove(subArea)
                                subAreasArr.add(subArea)
                                
                                let ssbAreasArr = NSMutableArray.init(array: [])
                                let rsstArr: [TsvAddressModel] = recordsMutable as! [TsvAddressModel]
                                for ssbArea in rsstArr {
                                   if ssbArea.parent_id == subArea.id {
                                       // 第三层层
                                       recordsMutable.remove(ssbArea)
                                       ssbAreasArr.add(ssbArea)
                                       
                                    
                                   }
                                }
                                
                                if ssbAreasArr.count > 0 {
                                    subArea.subAddressModel = ssbAreasArr as? [TsvAddressModel]
                                }
                            }
                        }
                        if subAreasArr.count > 0 {
                            area.subAddressModel = subAreasArr as? [TsvAddressModel]
                        }
                    }
                }
                
                self.aresList = (areasArr as? [TsvAddressModel]) ?? []
                self.contentsCollection.reloadData()
            }
        }
    }
    
}

extension AddressPicker: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == titlesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath) as! AddressPickerTitleCell
            cell.titleLb.text = titlesArr[indexPath.row]
            if indexPath.row == selectedTitleIndex {
                cell.titleLb.textColor = JAPickerMTextBlackColor
                cell.titleLb.font = UIFont.init(name: "PingFangSC-Semibold", size: 16)
//                cell.idicateView.isHidden = false
            }else{
//                cell.idicateView.isHidden = true
                cell.titleLb.textColor = JAPickerMTextLightColor
                cell.titleLb.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath) as! AddressPickerContentCell
            if indexPath.row == 0 {
                cell.list = aresList
            }else{
                cell.list = contentsList[indexPath.row]
            }
            cell.areaTap = {[unowned self](cityName, subArr) in
                // 标题更改
                self.titlesArr[indexPath.row] = cityName
                
                if let subs = subArr {
                    // 添加下一级标题
                    if subs.count > 0 {
                        
                        // 内容数组更改
                        if  self.contentsList.count >= self.titlesArr.count  {
                            
                            self.contentsList =  Array(self.contentsList.prefix(indexPath.row + 1))
                            self.contentsList.append(subs)
                            self.titlesArr = Array(self.titlesArr.prefix(indexPath.row + 1))
                            
                        }else{
                            self.contentsList.append(subs)
                        }
                        self.titlesArr.append("请选择")
                    }
                }
                // 标题更改完成
    
                self.titlesCollection.reloadData()
                self.contentsCollection.reloadData()
                
                if(indexPath.row + 1 < self.titlesArr.count) {
                     self.contentsCollection.scrollToItem(at: IndexPath.init(row: indexPath.row+1, section: 0), at: .right, animated: true)
                }
                
                // 传出最终结果
                if indexPath.row == 2 {
                    self.didSelect(items: self.titlesArr)
                    self.removeFromSuperview()
                }
            }
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentsCollection {
            return contentsCollection.bounds.size
        }else{
            let titleStr = titlesArr[indexPath.row]
            if indexPath.row == selectedTitleIndex {
                let font = UIFont.init(name: "PingFangSC-Semibold", size: 16)!
                let width = JAPickerTextWidth(textStr: titleStr, font: font, height: 22)
                return CGSize.init(width: width, height: 42)
            }else{
                let font = UIFont.init(name: "PingFangSC-Regular", size: 16)!
                let width = JAPickerTextWidth(textStr: titleStr, font: font, height: 22)
                return CGSize.init(width: width, height: 42)
            }
           
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == titlesCollection {
            if(indexPath.row  < self.titlesArr.count) {
                if indexPath.row == selectedTitleIndex {
                    return
                }
                
                self.contentsCollection.scrollToItem(at: IndexPath.init(row: indexPath.row, section: 0), at: .right, animated: true)
                let lastCell = collectionView.cellForItem(at: IndexPath.init(row: selectedTitleIndex, section: 0)) as? AddressPickerTitleCell
//                lastCell?.idicateView.isHidden = true
                
                let cell = collectionView.cellForItem(at: indexPath) as? AddressPickerTitleCell
//                cell?.idicateView.isHidden = false
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == contentsCollection {
            selectedTitleIndex = indexPath.row
            titlesCollection.reloadData()
        }
    }
    
}


extension UIView {
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat, _ maskBounds: CGRect? = nil) {
        let maskPath = UIBezierPath(roundedRect: maskBounds ?? bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
