import SwiftUI

struct ShareRootView: View {
    let context: NSExtensionContext?
    let loader: SharedContentLoader

    @State private var sourceText = ""
    @State private var translatedText = ""
    @State private var targetLanguage: LanguageOption = .english
    @State private var status = "Loading shared content..."

    private let engine: TranslationEngine = LocalModelTranslationEngine()

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Picker("To", selection: $targetLanguage) {
                    ForEach(LanguageOption.translatableCases) { language in
                        Text(language.name).tag(language)
                    }
                }
                .pickerStyle(.menu)

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(sourceText.isEmpty ? status : sourceText)
                            .font(.body)
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Divider()

                        Text(translatedText.isEmpty ? "Translation appears here." : translatedText)
                            .font(.title3)
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }

                HStack {
                    Button("Cancel") {
                        context?.cancelRequest(withError: ShareExtensionError.cancelled)
                    }
                    .buttonStyle(.bordered)

                    Button("Translate") {
                        Task { await translate() }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(sourceText.isEmpty)

                    Button("Done") {
                        context?.completeRequest(returningItems: nil)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationTitle("LocalLens")
            .task {
                await loadContent()
            }
            .onChange(of: targetLanguage) { _, _ in
                Task { await translate() }
            }
        }
    }

    private func loadContent() async {
        do {
            sourceText = try await loader.loadTextOrRecognizeImage()
            status = "Ready."
            await translate()
        } catch {
            status = error.localizedDescription
        }
    }

    private func translate() async {
        guard !sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        do {
            let request = TranslationRequest(
                text: sourceText,
                sourceLanguage: .auto,
                targetLanguage: targetLanguage
            )
            translatedText = try await engine.translate(request)
            status = "Done."
        } catch {
            translatedText = ""
            status = error.localizedDescription
        }
    }
}

enum ShareExtensionError: LocalizedError {
    case cancelled

    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "The translation was cancelled."
        }
    }
}

