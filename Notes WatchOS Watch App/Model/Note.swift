//
//  Note.swift
//  Notes WatchOS Watch App
//
//  Created by Vlad V on 06.11.2022.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    let text: String
}
