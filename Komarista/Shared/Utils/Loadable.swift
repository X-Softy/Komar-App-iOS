//
//  Loadable.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/21/21.
//

import SwiftUI

typealias LoadableSubject<T> = Binding<Loadable<T>>

enum Loadable<T> {
    case notRequested
    case isLoading
    case loaded(T)
    case failed(ErrorEntity)
}
