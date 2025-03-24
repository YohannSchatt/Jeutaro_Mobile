//
//  ContentView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isMenuOpen = false
    @EnvironmentObject var routeur: Routeur
    @EnvironmentObject var userViewModel: UserViewModel
    
    let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.75
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Vue principale (toujours fixe)
                NavigationView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Overlay semi-transparent quand le menu est ouvert
                if isMenuOpen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.25)) {
                                self.isMenuOpen = false
                            }
                        }
                        .transition(.opacity)
                }
                
                // Menu de navigation (glisse depuis la gauche)
                if isMenuOpen {
                    NavigationSelectionView()
                        .frame(width: menuWidth)
                        .background(Color.white)
                        .shadow(color: .black.opacity(0.3), radius: 5)
                        .transition(.move(edge: .leading))
                }
                
                // Bouton de menu (toujours visible)
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.25)) {
                                self.isMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: isMenuOpen ? "xmark" : "line.horizontal.3")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)
                                .padding(.leading, 16)
                                .padding(.top, 16)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
            .animation(.easeOut(duration: 0.25), value: isMenuOpen)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Routeur())
            .environmentObject(UserViewModel(routeur: Routeur()))
    }
}