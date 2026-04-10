//
//  ContentView.swift
//  Bike
//
//  Created by Johan Olea on 10/04/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var playerViewModel = PlayerViewModel()

    var body: some View {
        NavigationStack {
            PlayerView(viewModel: playerViewModel)
                .navigationTitle("Bike")
        }
    }
}
