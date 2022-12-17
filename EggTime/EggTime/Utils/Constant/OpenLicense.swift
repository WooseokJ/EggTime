//
//  OpenLicenseEnum.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import Foundation

enum OpenLicense: CaseIterable {
    
    case license
    var list: [String] {
        switch self{
        case .license:
            return ["Realm","Snapkit","Zip","NMapsMap"]
        }
    }
    
    
}
