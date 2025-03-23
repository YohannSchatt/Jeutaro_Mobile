//
//  SessionEditView.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//

import SwiftUI

struct SessionEditView: View {
    @ObservedObject var viewModel: SessionEditViewModel
    let editMode: Bool
    @EnvironmentObject var routeur: Routeur
    
    @State private var titre: String = ""
    @State private var lieu: String = ""
    @State private var dateDebut: Date = Date()
    @State private var dateFin: Date = Date().addingTimeInterval(7*24*60*60) // One week from now
    @State private var description: String = ""
    @State private var comission: String = ""
    
    @State private var isDatePickerShown = false
    @State private var selectedDate: Date = Date()
    @State private var selectedDateField: DateField = .debut
    
    enum DateField {
        case debut, fin
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Back navigation button
            Button(action: {
                // Go back to management view
                routeur.setRoute(route: AnyView(SessionManagementView().environmentObject(routeur)))
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Retour")
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding([.horizontal, .top])
            
            // Form content in ScrollView
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Title
                    TitreField
                    LieuField
                    DateDebutField
                    DateFinField
                    DescriptionField
                    ComissionField
                    SaveButton
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            loadSessionData()
        }
        .overlay(
            viewModel.isLoading ?
                ProgressView("Traitement en cours...")
                .frame(width: 200, height: 200)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                : nil
        )
    }
    
    private var Title: some View {
        Text(editMode ? "Modifier la session" : "Nouvelle session")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
    }
    
    private var TitreField: some View {
        VStack(alignment: .leading) {
            Text("Titre")
                .fontWeight(.medium)
            
            TextField("Titre de la session", text: $titre)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 2)
        }
    }
    
    private var LieuField: some View {
        VStack(alignment: .leading) {
            Text("Lieu")
                .fontWeight(.medium)
            
            TextField("Lieu de la session", text: $lieu)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 2)
        }
    }
    
    private var DateDebutField: some View {
        VStack(alignment: .leading) {
            Text("Date de début")
                .fontWeight(.medium)
            
            Button(action: {
                selectedDateField = .debut
                selectedDate = dateDebut
                isDatePickerShown = true
            }) {
                HStack {
                    Text(viewModel.formatDateForDisplay(dateDebut))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .sheet(isPresented: $isDatePickerShown) {
                DatePickerView(
                    selectedDate: $selectedDate,
                    isPresented: $isDatePickerShown,
                    onSave: {
                        if selectedDateField == .debut {
                            dateDebut = selectedDate
                        } else {
                            dateFin = selectedDate
                        }
                    }
                )
            }
        }
    }
    
    private var DateFinField: some View {
        VStack(alignment: .leading) {
            Text("Date de fin")
                .fontWeight(.medium)
            
            Button(action: {
                selectedDateField = .fin
                selectedDate = dateFin
                isDatePickerShown = true
            }) {
                HStack {
                    Text(viewModel.formatDateForDisplay(dateFin))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
    
    private var DescriptionField: some View {
        VStack(alignment: .leading) {
            Text("Description")
                .fontWeight(.medium)
            
            TextEditor(text: $description)
                .frame(height: 100)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
    }
    
    private var ComissionField: some View {
        VStack(alignment: .leading) {
            Text("Commission (%)")
                .fontWeight(.medium)
            
            TextField("Commission (ex: 5)", text: $comission)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding(.vertical, 2)
        }
    }
    
    private var SaveButton: some View {
        Button(action: {
            Task {
                await viewModel.saveSession(
                    titre: titre,
                    lieu: lieu,
                    dateDebut: dateDebut,
                    dateFin: dateFin,
                    description: description,
                    comission: comission
                )
                
                // Go back to the management view after saving
                if viewModel.error == nil {
                    routeur.setRoute(route: AnyView(SessionManagementView().environmentObject(routeur)))
                }
            }
        }) {
            Text(editMode ? "Mettre à jour" : "Créer")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.vertical)
    }
    
    private func loadSessionData() {
        if editMode && viewModel.idSessionSelected >= 0 && viewModel.idSessionSelected < viewModel.sessions.count {
            let selectedSession = viewModel.sessions[viewModel.idSessionSelected]
            titre = selectedSession.titre
            lieu = selectedSession.lieu
            dateDebut = selectedSession.dateDebut
            dateFin = selectedSession.dateFin
            description = selectedSession.description
            comission = String(selectedSession.comission)
        } else {
            // Reset form for new session
            titre = ""
            lieu = ""
            dateDebut = Date()
            dateFin = Date().addingTimeInterval(7*24*60*60)
            description = ""
            comission = "5"
        }
    }
}

// Custom date picker view
struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    var onSave: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler") {
                    isPresented = false
                }
                
                Spacer()
                
                Button("Enregistrer") {
                    onSave()
                    isPresented = false
                }
            }
            .padding()
            
            DatePicker(
                "Sélectionnez une date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            Spacer()
        }
    }
}

struct SessionEditView_Previews: PreviewProvider {
    static var previews: some View {
        SessionEditView(viewModel: SessionEditViewModel(), editMode: false)
            .environmentObject(Routeur())
    }
}