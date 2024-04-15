//
//  Sample_SwiftUIApp.swift
//  Sample-SwiftUI
//
//  Created by io.numerator on 04/03/2024.
//

import SwiftUI
import NumeratorSDK

@main
struct Sample_SwiftUIApp: App {
  
  /// You need to create Project in the Numerator Console and get your API Key
  /// And create feature flag with Test Case is Defined in [Demo: Integrating numerator-sdk. coffee]
  
  init() {
    NumeratorFeatureFlagProvider.configure(
      apiKey: "YOUR_API_KEY",
      pollingConfig: PollingModes.autoPoll(autoPollIntervalSeconds: 16)
    )
    NumeratorFeatureFlagProvider.shared.printToConsole(true)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
