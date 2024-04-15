//
//  ContentView.swift
//  Sample-SwiftUI
//
//  Created by io.numerator on 04/03/2024.
//

import SwiftUI
import NumeratorSDK
import Combine

struct ContentView: View {
  
  @NumeratorFeatureFlag(
    key: "enable_land_pet",
    defaultValue: false,
    flagProvider: NumeratorFeatureFlagProvider.shared
  ) var boolFlag: Bool
  
  @NumeratorFeatureFlag(
    key: "rare_animal",
    defaultValue: "Not a rare animal",
    flagProvider: NumeratorFeatureFlagProvider.shared
  ) var rareAnimalFlag: String
  
  @NumeratorFeatureFlag(
    key: "image_size",
    defaultValue: 1,
    flagProvider: NumeratorFeatureFlagProvider.shared
  ) var imageSizeFlag: Int
  
  @State private var currentTitle: String = "What kind of land animal is it?"
  @State private var guess = ""
  @State private var result = ""
  @State private var isWinGamge = false
  @State private var rareAnimal = ""
  @State private var pets = ["cat", "dog", "rabbit", "lion", "deer"]
  @State private var currentPetIndex = Int.random(in: 0..<5)
  @State private var showPlayAgain = false
  
  var landPets = ["cat", "dog", "rabbit", "lion", "deer"]
  var seaPets = ["fish", "whale", "shark", "starfish", "penguin"]
  
  var body: some View {
    contentView
      .onReceive(NumeratorFeatureFlagProvider.shared.flagUpdatedPublisher) { _ in
        print("Feature flag is updated")
      }
      .onReceive(NumeratorFeatureFlagProvider.shared.flagUpdatedErrorPublisher) { error in
        print("Feature flag is update error:\(error)")
      }
  }
  
  @ViewBuilder
  var contentView: some View {
    ScrollView {
      VStack {
        HStack {
          Text("Reset game")
            .font(.title3)
          Button(action: {
            resetGame()
          }) {
            Image(systemName: "arrow.counterclockwise")
              .font(.title)
          }
          .buttonStyle(.borderless)
          Spacer()
        }
        .padding(.bottom, 5)
        
        Text(currentTitle)
          .font(.title)
          .multilineTextAlignment(.center)
          .lineLimit(2)
        
        Image(pets[currentPetIndex])
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: imageSizeFlag == 1 ? 480 : CGFloat(imageSizeFlag))
          .overlay(content: {
            overLayResult
              .opacity(result.isEmpty ? 0 : 1)
          })
        
        TextField("Enter your guess", text: $guess)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.top)
        
        Button(action: {
          if showPlayAgain {
            showPlayAgain = false
            resetGame()
          } else {
            checkGuess()
            Task { @MainActor in
              await getRareAnimal(with: guess)
            }
          }
        }) {
          Text(showPlayAgain ? "Play Again" : "Submit Guess")
            .frame(maxWidth: .infinity)
            .frame(height: 8)
        }
        .buttonStyle(GrowingButton())
        
        Text(rareAnimal)
          .font(.title)
          .foregroundStyle(.red.gradient)
      }
      .padding()
    }
  }
  
  var overLayResult: some View {
    VStack {
      Text(result)
        .font(.title)
        .padding(6)
        .foregroundColor(.white)
    }.background(isWinGamge ? Color.green : Color.red)
      .opacity(0.65)
      .cornerRadius(10.0)
      .padding(6)
  }
  
  
  func resetGame() {
    guess = ""
    result = ""
    currentPetIndex = Int.random(in: 0..<pets.count)
  }
  
  func checkGuess() {
    if guess.lowercased() == pets[currentPetIndex].lowercased() {
      result = "Correct!"
      showPlayAgain = true
      isWinGamge = true
    } else {
      result = "Incorrect! Try again."
      isWinGamge = false
    }
  }
  
  func getRareAnimal(with guessName: String) async {
    /// If you want to get flag without context you can use this method
    //rareAnimal = stringFlag
    
    /// In this case we need get flag with context so we use this method
    let stringValue = await NumeratorFeatureFlagProvider.shared.getStringFeatureFlag(
      key: "rare_animal",
      defaultValue: "Not a rare animal",
      context: ["rare_animal": guessName.lowercased()]
    )
    rareAnimal = stringValue
  }
  
}


struct GrowingButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding()
      .background(.blue)
      .foregroundStyle(.white)
      .clipShape(Capsule())
      .scaleEffect(configuration.isPressed ? 1.35 : 1)
      .animation(.easeOut(duration: 0.35), value: configuration.isPressed)
  }
}

#Preview {
  ContentView()
}
