//
//  Tarea7App.swift
//  Tarea7
//
//  Created by Daniel Cubillo on 25/3/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct Tarea7App: App {
    init() {
            configureAmplify()
        }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func configureAmplify(){
        do {
            Amplify.Logging.logLevel = .verbose
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            
            print("Amplify configured with auth plugin")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
    }
    
    
}
