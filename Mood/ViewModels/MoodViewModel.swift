//
//  MoodViewModel.swift
//  Mood
//
//  Created by Owner on 11/16/24.
//

import FirebaseFirestore

class MoodViewModel: ObservableObject {
    @Published var moods: [MoodModel] = []
    @Published var errorMessage: String?
    private var db = Firestore.firestore()

    func fetchMoods() {
        db.collection("moods")
            .order(by: "timestamp")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    self.errorMessage = "Error fetching data: \(error.localizedDescription)"
                } else {
                    self.moods = snapshot?.documents.compactMap { document in
                        try? document.data(as: MoodModel.self)
                    } ?? []
                }
            }
    }

    func addMood(mood: String, note: String) {
        let newMood = MoodModel(mood: mood, note: note, timestamp: Date())
        do {
            _ = try db.collection("moods").addDocument(from: newMood)
        } catch {
            errorMessage = "Error adding mood: \(error.localizedDescription)"
        }
    }

    func updateMood(mood: MoodModel) {
        guard let moodId = mood.id else {
            errorMessage = "Mood ID is missing."
            return
        }

        db.collection("moods").document(moodId).getDocument { (document, error) in
            if let error = error {
                self.errorMessage = "Error fetching document: \(error.localizedDescription)"
                return
            }

            if let document = document, document.exists {
                do {
                    try self.db.collection("moods").document(moodId).setData(from: mood) { error in
                        if let error = error {
                            self.errorMessage = "Error updating mood: \(error.localizedDescription)"
                        } else {
                            self.fetchMoods()
                        }
                    }
                } catch {
                    self.errorMessage = "Error serializing mood: \(error.localizedDescription)"
                }
            } else {
                self.errorMessage = "Document not found for the given mood ID."
            }
        }
    }

    func deleteMood(mood: MoodModel) {
        guard let moodId = mood.id else {
            errorMessage = "Mood ID is missing."
            return
        }
        
        db.collection("moods").document(moodId).delete { error in
            if let error = error {
                self.errorMessage = "Error deleting mood: \(error.localizedDescription)"
            } else {
                self.fetchMoods()
            }
        }
    }
}
