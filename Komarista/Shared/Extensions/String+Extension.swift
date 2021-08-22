//
//  String+Extension.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Foundation
import SwiftUI

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
    var asKey: LocalizedStringKey { .init(self) }
}
