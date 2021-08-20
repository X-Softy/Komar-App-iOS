//
//  Bundle+Extension.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/18/21.
//

import Foundation

extension Bundle {
    var baseURL: String {
        "https://europe-west3-komar-app.cloudfunctions.net/api" // infoDictionary?["API_HOST"] as! String
    }
}
