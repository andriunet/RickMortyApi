//
//  String+.swift
//  RickMorty
//
//  Created by Andres on 16/06/25.
//

import Foundation

extension String {
    func formattedDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: self) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES") // Idioma español
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
}
