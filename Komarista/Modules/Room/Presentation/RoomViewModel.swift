//
//  RoomViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Combine
import SwiftUI

extension Room {
    class ViewModel: ObservableObject {
        struct Params {
            let room: RoomBrief
        }

        let params: Params

        init(with params: Params) {
            self.params = params
        }
    }
}
