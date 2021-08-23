//
//  RoomsViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Combine
import SwiftUI

extension Rooms {
    class ViewModel: ObservableObject {
        struct Params {
            let category: Category
        }

        let params: Params

        init(with params: Params) {
            self.params = params
        }
    }
}
