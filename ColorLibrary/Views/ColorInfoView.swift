//
//  ColorInfoView.swift
//  ColorLibrary
//
//  Created by Vivien BERNARD on 20/04/2023.
//

import SwiftUI

@MainActor private final class CloseColorsLoader: ObservableObject {
    @Published private(set) var colors = [ColorInfo]()
    
    private var loadingTask: Task<Void, Error>?
    
    init() {}
    
    deinit { loadingTask?.cancel() }
    
    private func setColors(_ colors: [ColorInfo]) {
        self.colors = colors
    }
    
    func loadCloseColors(to color: ColorInfo,
                         dataBase: ColorDataBase,
                         distance: CGFloat = 0.8,
                         loadAfter time: TimeInterval = 0) {
        loadingTask?.cancel()
        
        // Nous sommes dans le MainActor, donc on détache une tache du MainActor
        // et cette tache permet de calculer les couleurs proches.
        loadingTask = Task.detached(priority: .background) { [weak self] in
            try await Task.sleep(for: .seconds(time))
            
            let colors = try dataBase.closeColors(to: color, distance: distance)
            await self?.setColors(colors)
        }
    }
}

struct ColorInfoView: View {
    @EnvironmentObject private var colorDataBase: ColorDataBase
    @ObservedObject private(set) var info: ColorInfo
    @StateObject private var closeColorsLoader = CloseColorsLoader()
    @State private var isColorMainFocus = false
    let showsCloseColors: Bool
    
    init(_ info: ColorInfo, showsCloseColors: Bool = true) {
        self.info = info
        self.showsCloseColors = showsCloseColors
    }
    
    @ScaledMetric private var closeColorsViewHeight = 85
    @ScaledMetric private var closeColorsItemWidth = 60
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                ColorCircle(info, scale: isColorMainFocus ? 8 : 3)
                
                TextField("Title", text: $info.title)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 200)
            }
            
            Spacer()
            
            slidersView
            
            Spacer()
            
            if showsCloseColors && !isColorMainFocus {
                if !closeColorsLoader.colors.isEmpty {
                    closeColorsView(closeColorsLoader.colors)
                }
            }
        }.onReceive(info.objectWillChange) {
            closeColorsLoader.loadCloseColors(to: info,
                                              dataBase: colorDataBase,
                                              loadAfter: 0.2)
        }.onAppear {
            closeColorsLoader.loadCloseColors(to: info,
                                              dataBase: colorDataBase)
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.spring()) {
                        isColorMainFocus.toggle()
                    }
                } label: {
                    FullScreenArrows(isFullScreen: !isColorMainFocus)
                        .stroke(style: .init(lineWidth: 2, lineCap: .round))
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
    
    private var slidersView: some View {
        Grid(alignment: .trailing) {
            GridRow {
                Text("Red").bold()
                ColorSlider(value: $info.red,
                            leading: info.red(0).uiColor,
                            trailing: info.red(1).uiColor)
                Text(String(format: "%0.2f", info.red))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            GridRow {
                Text("Green").bold()
                ColorSlider(value: $info.green,
                            leading: info.green(0).uiColor,
                            trailing: info.green(1).uiColor)
                Text(String(format: "%0.2f", info.green))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            GridRow {
                Text("Blue").bold()
                ColorSlider(value: $info.blue,
                            leading: info.blue(0).uiColor,
                            trailing: info.blue(1).uiColor)
                Text(String(format: "%0.2f", info.blue))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }.padding(.horizontal, 16)
    }
    
    private func closeColorsView(_ closeColors: [ColorInfo]) -> some View {
        VStack(alignment: .leading) {
            Text("Close colors")
                .font(.title3).bold()
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(closeColors) { color in
                        NavigationLink(value: color) {
                            VStack {
                                ColorCircle(color, scale: 2)
                                Text(color.title)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: closeColorsItemWidth)
                        }.transition(.opacity.combined(with: .scale))
                    }
                }.padding(.horizontal, 16)
            }
            .frame(height: closeColorsViewHeight)
            .animation(.default, value: closeColors)
        }
    }
}

struct ColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorInfoView(.cantaloupe, showsCloseColors: true)
            .environmentObject(ColorDataBase.demo)
    }
}
