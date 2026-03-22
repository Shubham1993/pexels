//
//  PexelsApp.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import SwiftUI

@main
struct PexelsApp: App {
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: container.makeHomeViewModel())
        }
    }
}
