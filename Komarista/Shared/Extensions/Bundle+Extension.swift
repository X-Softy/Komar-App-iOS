//
//  Bundle+Extension.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/18/21.
//

import Foundation

extension Bundle {
    var scheme: HTTPSchemeType {
        HTTPSchemeType(rawValue: infoDictionary?["API_SCHEME"] as! String)!
    }
    var host: String {
        infoDictionary?["API_HOST"] as! String
    }
}
