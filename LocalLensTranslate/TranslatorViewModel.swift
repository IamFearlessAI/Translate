import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class TranslatorViewModel: ObservableObject {
    @Published var sourceText = ""
    @Published var translatedText = ""
    @Published var sourceLanguage: LanguageOption = .auto
    @Published var targetLanguage: LanguageOption = .english
    @Published var statusMessage: String?

    private let ocrService = OCRService()
    private let translationEngine: TranslationEngine = LocalModelTranslationEngine()

    func translateSourceText() async {
        let trimmed = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            statusMessage = "Enter text or import an image first."
            return
        }

        statusMessage = "Translating locally..."
        do {
            let request = TranslationRequest(
                text: trimmed,
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage
            )
            translatedText = try await translationEngine.translate(request)
            statusMessage = "Done."
        } catch {
            translatedText = ""
            statusMessage = error.localizedDescription
        }
    }

    func extractText(from item: PhotosPickerItem?) async {
        guard let item else { return }
        statusMessage = "Reading image locally..."

        do {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                statusMessage = "Could not load image data."
                return
            }
            let text = try await ocrService.recognizeText(in: data)
            sourceText = text
            await translateSourceText()
        } catch {
            statusMessage = error.localizedDescription
        }
    }

    func swapLanguages() {
        guard sourceLanguage != .auto else { return }
        let oldSource = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = oldSource
        if !translatedText.isEmpty {
            sourceText = translatedText
            translatedText = ""
        }
    }
}

