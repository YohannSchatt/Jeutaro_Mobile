//
//  ContentView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isMenuOpen = false

    var body: some View {
        ZStack {
            NavigationView()
            if isMenuOpen {
                Color.black.opacity(0.5).blur(radius: 20)
                    .edgesIgnoringSafeArea(.all)
                HStack {
                    Spacer()
                    NavigationSelectionView()
                        .transition(.move(edge: .leading))
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundColor(Color.black)
                    }
                    .background(DefineColor.color1.color)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding(10)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Routeur())
    }
}
