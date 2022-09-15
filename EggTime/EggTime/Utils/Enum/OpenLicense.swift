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
            return ["기술명1","기술명2","기술명3"]
        }
    }
    
    
}
