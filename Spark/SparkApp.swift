//
//  SparkApp.swift
//  Spark
//
//  Created by Gurkeerat on 03/03/24.
//

import SwiftUI

@main
struct SparkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
