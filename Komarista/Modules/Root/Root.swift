//
//  Root.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct Root: View {
    @ObservedObject private var userSession: UserSession = .shared

    var body: some View {
        if userSession.state == nil { SignIn() }
        else { Home() }
    }
}

struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root()
    }
}
