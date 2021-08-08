//
//  ContentView.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/7/21.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var googleDelegate: GoogleDelegate

    var body: some View {
        Group {
            if googleDelegate.signedIn {
                VStack {
                    Button(action: {
                        GIDSignIn.sharedInstance()?.signOut()
                        googleDelegate.signedIn = false
                    }) {
                        Text("Sign Out")
                    }
                }
            } else {
                Button(action: {
                    GIDSignIn.sharedInstance()?.signIn()
                }) {
                    Text("Sign In")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
