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
  
  init() {
    NumeratorFeatureFlagProvider.configure(
      apiKey: "NUM.PbmFqVAzzHbUlieb1f51Fg==.5BsoRn9KBLCTMOiEmBxzX2hgEsP3raI61bXQ4dRKCXhzyzGNcyII+FWTUipNHi+E",
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
