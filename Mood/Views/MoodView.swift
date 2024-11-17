//
//  ContentView.swift
//  Mood
//
//  Created by Owner on 11/16/24.
//

import SwiftUI

struct MoodView: View {
    @ObservedObject var viewModel = MoodViewModel()

    var body: some View {
        VStack {
            NavigationLink(destination: MoodDetailView(viewModel: viewModel)) {
                Text("Add New Mood")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            List(viewModel.moods) { mood in
                NavigationLink(destination: MoodDetailView(mood: mood, viewModel: viewModel)) {
                    VStack(alignment: .leading) {
                        Text(mood.mood)
                            .font(.headline)
                        Text(mood.note)
                            .font(.subheadline)
                        Text("Timestamp: \(mood.timestamp, style: .date)")
                            .font(.caption)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchMoods()
        }
        .navigationTitle("Moods")
        .padding()
    }
}

