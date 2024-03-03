//
// ContentView.swift
// Spark
//
// Created by Gurkeerat on 03/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ContentView: View {

  @State private var showImmersiveSpace = false
  @State private var immersiveSpaceIsShown = false

  @State private var quote: Quote? = nil

  @Environment(\.openImmersiveSpace) var openImmersiveSpace
  @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

  // Define your Quote model based on the API response structure
  struct Quote: Codable {
    let content: String
    let author: String
    // ... add other properties as needed based on the API response
  }

  private func fetchQuote() async {
    guard let url = URL(string: "https://api.quotable.io/random") else { return }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      quote = try decoder.decode(Quote.self, from: data)
    } catch {
      print("Error fetching quote: \(error)")
    }
  }

  var body: some View {
    VStack {
        
      // Conditionally display the quote or loading message
      if let quote = quote {
        Text(quote.content)
          .padding()
          
        Text(quote.author)
            .padding()
          
        // Button to fetch a new quote
          Button("Enlighten Me!") {
            Task {
              await fetchQuote()
            }
          }
          .padding(.top, 20)
          
      } else {
        Text("Loading quote...")
      }
    }
    .padding()
    .onAppear {
      Task {
        await fetchQuote()
      }
    }
    .onChange(of: showImmersiveSpace) { _, newValue in
      Task {
        if newValue {
          switch await openImmersiveSpace(id: "ImmersiveSpace") {
          case .opened:
            immersiveSpaceIsShown = true
          case .error, .userCancelled:
            fallthrough
          @unknown default:
            immersiveSpaceIsShown = false
            showImmersiveSpace = false
          }
        } else if immersiveSpaceIsShown {
          await dismissImmersiveSpace()
          immersiveSpaceIsShown = false
        }
      }
    }
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
}
