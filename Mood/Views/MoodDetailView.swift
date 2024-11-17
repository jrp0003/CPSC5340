//
//  MoodDetailView.swift
//  Mood
//
//  Created by Owner on 11/16/24.
//

import SwiftUI

struct MoodDetailView: View {
   @State private var moodText: String
   @State private var noteText: String
   @State private var timestamp: Date
   var mood: MoodModel?
   var viewModel: MoodViewModel
    @Environment(\.presentationMode) private var presentationMode

   init(mood: MoodModel? = nil, viewModel: MoodViewModel) {
       if let mood = mood {
           _moodText = State(initialValue: mood.mood)
           _noteText = State(initialValue: mood.note)
           _timestamp = State(initialValue: mood.timestamp)
           self.mood = mood
       } else {
           _moodText = State(initialValue: "")
           _noteText = State(initialValue: "")
           _timestamp = State(initialValue: Date())
           self.mood = nil
       }
       self.viewModel = viewModel
   }

   var body: some View {
       VStack {
           TextField("Mood", text: $moodText)
               .padding()
               .textFieldStyle(RoundedBorderTextFieldStyle())

           TextField("Note", text: $noteText)
               .padding()
               .textFieldStyle(RoundedBorderTextFieldStyle())

           Button(action: {
               if let mood = mood {
                   let updatedMood = MoodModel(id: mood.id, mood: moodText, note: noteText, timestamp: timestamp)
                   viewModel.updateMood(mood: updatedMood)
               } else {
                   viewModel.addMood(mood: moodText, note: noteText)
               }
               presentationMode.wrappedValue.dismiss()
           }) {
               Text(mood != nil ? "Update Mood" : "Save Mood")
                   .padding()
                   .background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(10)
           }
                if mood != nil {
                    Button(action: {
                        if let mood = mood {
                            viewModel.deleteMood(mood: mood)
                        }
                    }) {
                        Text("Delete Mood")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        
        .padding()
        .navigationTitle(mood != nil ? "Edit Mood" : "Add New Mood")
    }
}
