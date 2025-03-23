//
//  SessionManagementView.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//

import SwiftUI

struct SessionManagementView: View {
    @StateObject private var viewModel = SessionEditViewModel()
    @EnvironmentObject var routeur: Routeur
    @State private var navigateToEdit = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Add a dismiss button in the toolbar for better navigation
            Button("Retour") {
                dismiss()
            }
            .padding(.horizontal)
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Sessions list
            List {
                ForEach(Array(viewModel.sessions.enumerated()), id: \.element.id) { index, session in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.titre)
                                .font(.headline)
                            
                            Text(session.lieu)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(session.formattedDateRange)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.setIdSessionSelected(index: index)
                            // Route to edit view
                            routeur.setRoute(route: AnyView(SessionEditView(
                                viewModel: viewModel,
                                editMode: viewModel.idSessionSelected != -1
                            ).environmentObject(routeur)))
                        }) {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.setIdSessionSelected(index: index)
                        navigateToEdit = true
                    }
                    .background(viewModel.idSessionSelected == index ? Color.blue.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                Task {
                    await viewModel.loadSessions()
                }
            }
            
            Divider()
            
            // Action buttons
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.setIdSessionSelected(index: -1)
                    navigateToEdit = true
                }) {
                    Label("Nouvelle", systemImage: "plus.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    Task {
                        await viewModel.deleteSession()
                    }
                }) {
                    Label("Supprimer", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.idSessionSelected == -1 ? Color.gray : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.idSessionSelected == -1)
                .opacity(viewModel.idSessionSelected == -1 ? 0.5 : 1.0)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            if !viewModel.message.isEmpty {
                Text(viewModel.message)
                    .foregroundColor(viewModel.error != nil ? .red : .green)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Gestion des Sessions")
        .overlay(
            viewModel.isLoading ?
                ProgressView("Chargement...")
                .frame(width: 200, height: 200)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                : nil
        )
    }
}

struct SessionManagementView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SessionManagementView()
                .environmentObject(Routeur())
        }
    }
}
