//
//  Font+Extension.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 01.09.21.
//

import SwiftUI

extension Font {
    static var safeTitle2: Font {
        if #available(iOS 14.0, *) { return .title2 }
        else { return .title }
    }

    static var safeTitle3: Font {
        if #available(iOS 14.0, *) { return .title3 }
        else { return .title }
    }
}
