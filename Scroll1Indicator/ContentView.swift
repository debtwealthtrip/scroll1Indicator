//
//  ContentView.swift
//  Scroll1Indicator
//
//  Created by sam win on 7/10/25.
//

import SwiftUI

// MARK: - Model: Represents each scrollable item
struct ScrollTargetItem: Identifiable, Hashable {
    let id = UUID()
    let color: Color
    let index: Int
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var horizontalScrollID: UUID?
    @State private var verticalScrollID: UUID?

    let items = (0..<33).map { ScrollTargetItem(color: .random, index: $0) }

    var body: some View {
        VStack(spacing: 30) {
            scrollButtons(
                title: "<< Horizontal >>",
                firstAction: { horizontalScrollID = items.first?.id },
                lastAction: { horizontalScrollID = items.last?.id }
            )
            .padding(.top)

            horizontalScrollSection

            Divider()

            scrollButtons(
                title: "<< Vertical >>",
                firstAction: { verticalScrollID = items.first?.id },
                lastAction: { verticalScrollID = items.last?.id }
            )

            verticalScrollSection
        }
        .padding()
    }

    // MARK: - Horizontal Scroll Section
    private var horizontalScrollSection: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(items) { item in
                        ScrollItemView(item: item, fontSize: .title2)
                            .frame(width: 160)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.visible) // <-- Scroll indicator
            .frame(height: 150)
            .onChange(of: horizontalScrollID) {
                if let id = horizontalScrollID {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
        }
    }

    // MARK: - Vertical Scroll Section
    private var verticalScrollSection: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 20) {
                    ForEach(items) { item in
                        ScrollItemView(item: item, fontSize: .title)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.visible) // <-- Scroll indicator
            .onChange(of: verticalScrollID) {
                if let id = verticalScrollID {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .top)
                    }
                }
            }
        }
    }

    // MARK: - Reusable Buttons
    @ViewBuilder
    private func scrollButtons(title: String, firstAction: @escaping () -> Void, lastAction: @escaping () -> Void) -> some View {
        HStack(spacing: 20) {
            Button("First", action: firstAction)
            Text(title)
                .font(.headline)
                .frame(width: 135, alignment: .leading)
            Button("Last", action: lastAction)
        }
        .font(.headline)
    }
}

// MARK: - Reusable Scroll Item View
struct ScrollItemView: View {
    let item: ScrollTargetItem
    let fontSize: Font

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(item.color)
            .frame(height: 120)
            .overlay(
                Text("Item \(item.index + 1)")
                    .font(fontSize)
                    .bold()
                    .foregroundColor(.white)
            )
            .id(item.id)
            .scrollTransition(.animated.threshold(.visible(0.6))) { view, phase in
                view
                    .scaleEffect(phase.isIdentity ? 1 : 0.8)
                    .opacity(phase.isIdentity ? 1 : 0.3)
            }
    }
}

// MARK: - Extension: Random vibrant color
extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0.4...1),
            green: .random(in: 0.4...1),
            blue: .random(in: 0.4...1)
        )
    }
}
#Preview {
    ContentView()
}
