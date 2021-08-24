//
//  ObservableObject+Extension.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/21/21.
//

import Combine
import SwiftUI

extension ObservableObject {
    func subject<Value>(_ keyPath: WritableKeyPath<Self, Value>) -> Binding<Value> {
        let defaultValue = self[keyPath: keyPath]
        return .init(get: { [weak self] in
            self?[keyPath: keyPath] ?? defaultValue
        }, set: { [weak self] in
            self?[keyPath: keyPath] = $0
        })
    }
}
