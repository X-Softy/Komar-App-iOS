//
//  Bundle+Extension.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/18/21.
//

import Foundation

extension Bundle {
    var baseURL: String { infoDictionary?["BASE_URL"] as! String }
}
