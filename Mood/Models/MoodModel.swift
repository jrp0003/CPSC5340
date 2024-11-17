//
//  MoodModel.swift
//  Mood
//
//  Created by Owner on 11/16/24.
//

import Foundation
import FirebaseFirestore

struct MoodModel: Identifiable, Codable {
    @DocumentID var id: String?
    var mood: String
    var note: String
    var timestamp: Date
}
