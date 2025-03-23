//
//  SessionModel.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//

import Foundation

struct Session: Identifiable {
    let id: Int
    let titre: String
    let lieu: String
    let dateDebut: Date
    let dateFin: Date
    let description: String
    let comission: Float
    
    // Computed properties for formatted dates
    var formattedDateDebut: String {
        formatDate(dateDebut)
    }
    
    var formattedDateFin: String {
        formatDate(dateFin)
    }
    
    var formattedDateRange: String {
        return "Du \(formattedDateDebut) au \(formattedDateFin)"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    // Factory method to convert from DTO
    static func fromDto(_ dto: GetSessionDto) -> Session? {
        // Create a proper ISO8601 formatter with extended configuration
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Declare date variables outside the guard statement
        var debut: Date
        var fin: Date
        
        // Try to parse dates with the enhanced formatter
        if let debutDate = formatter.date(from: dto.dateDebut),
           let finDate = formatter.date(from: dto.dateFin) {
            debut = debutDate
            fin = finDate
        } else {
            // Fallback to a more flexible date formatter
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            fallbackFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            guard let debutFallback = fallbackFormatter.date(from: dto.dateDebut),
                  let finFallback = fallbackFormatter.date(from: dto.dateFin) else {
                    print("⚠️ Failed to parse dates: \(dto.dateDebut) and \(dto.dateFin)")
                    return nil
            }
            
            debut = debutFallback
            fin = finFallback
        }
        
        // Parse the commission safely
        guard let comission = Float(dto.comission) else {
            print("⚠️ Failed to parse commission: \(dto.comission)")
            return nil
        }
        
        return Session(
            id: dto.idSession,
            titre: dto.titre,
            lieu: dto.lieu,
            dateDebut: debut,
            dateFin: fin,
            description: dto.description,
            comission: comission
        )
    }
}
