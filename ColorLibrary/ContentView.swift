//
//  ContentView.swift
//  ColorLibrary
//
//  Created by Vivien BERNARD on 20/04/2023.
//

import SwiftUI

struct ContentView: View {
    let colors: [ColorInfo] = [.blue, .cantaloupe, .carnation, .eggPlant, .green, .lemon, .orchid, .red, .salmon, .seaFoam]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(colors) { color in
                    NavigationLink(value: color) {
                        ColorInfoRow(color)
                    }
                }
            }
            .navigationTitle("Colors")
            .navigationDestination(for: ColorInfo.self) { color in
                ColorInfoView(color, closeColors: [.eggPlant, .orchid])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
