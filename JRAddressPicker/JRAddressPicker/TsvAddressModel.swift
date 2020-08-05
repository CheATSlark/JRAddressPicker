//
//  TsvAddressModel.swift
//  23
//
//  Created by 焦瑞洁 on 2020/2/26.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation

class TsvAddressModel {
    /*
     , short_name: String, depth: String, city_code: String, zip_code: String, merger_name: String,  longitude: String, latitude: String, pinyin: String, is_use: String
     */
    let id: String, city_name: String, parent_id: String
    var isSelected: Bool = false
    var subAddressModel: [TsvAddressModel]?
    init(id: String, city_name: String, parent_id: String) {
        /*
         , short_name: String, depth: String, city_code: String, zip_code: String, merger_name: String, longitude: String, latitude: String, pinyin: String, is_use: String
         */
        self.id = id
        self.city_name = city_name
        self.parent_id = parent_id
        /*
        self.short_name = short_name
        self.depth = depth
        self.city_code = city_code
        self.zip_code = zip_code
        self.merger_name = merger_name
        self.longitude = longitude
        self.latitude = latitude
        self.pinyin = pinyin
        self.is_use = is_use
         */
    }
}
