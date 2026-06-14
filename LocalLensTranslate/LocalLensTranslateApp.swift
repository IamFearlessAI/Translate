import SwiftUI

@main
struct LocalLensTranslateApp: App {
    @StateObject private var model = TranslatorViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}

