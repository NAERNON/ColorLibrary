//
//  ContentView.swift
//  ColorLibrary
//
//  Created by Vivien BERNARD on 20/04/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var colorDataBase: ColorDataBase
    @State private var newlyCreatedColor: ColorInfo?
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(colorDataBase.displayedColors) { color in
                    NavigationLink(value: color) {
                        ColorInfoRow(color)
                    }
                    .swipeActions(
                        edge: .leading,
                        allowsFullSwipe: false,
                        content: {
                            Button(
                                role: .destructive,
                                action: {
                                    colorDataBase.delete(color)
                                },
                                label: {
                                    Image(systemName: "trash")
                                }
                            )
                        }
                    )
                }
            }
            .navigationTitle("Colors")

            .navigationDestination(for: ColorInfo.self) { color in
                ColorInfoView(color)
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .onChange(
                of: searchText,
                perform: { _ in
                    colorDataBase.filter(searchText: searchText)
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newlyCreatedColor = .init(title: "Some color", red: 0.5, green: 0.5, blue: 0.5)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }.sheet(item: $newlyCreatedColor) { color in
            newColorSheet(for: color)
        }
    }
    
    private func newColorSheet(for color: ColorInfo) -> some View {
        NavigationStack {
            ColorInfoView(color, showsCloseColors: false)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            newlyCreatedColor = nil
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            colorDataBase.append(color)
                            newlyCreatedColor = nil
                        } label: {
                            Text("Add").bold()
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ColorDataBase.demo)
    }
}
