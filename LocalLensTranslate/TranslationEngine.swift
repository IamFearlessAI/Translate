import Foundation

struct TranslationRequest {
    let text: String
    let sourceLanguage: LanguageOption
    let targetLanguage: LanguageOption
}

protocol TranslationEngine {
    func translate(_ request: TranslationRequest) async throws -> String
}

enum TranslationEngineError: LocalizedError {
    case missingLocalModel(pair: String)

    var errorDescription: String? {
        switch self {
        case .missingLocalModel(let pair):
            return "No local translation model is bundled for \(pair). Add an on-device model in Models/ and wire it into LocalModelTranslationEngine."
        }
    }
}

final class LocalModelTranslationEngine: TranslationEngine {
    func translate(_ request: TranslationRequest) async throws -> String {
        let pair = "\(request.sourceLanguage.rawValue)-\(request.targetLanguage.rawValue)"

        if let demo = demoTranslation(for: request) {
            return demo
        }

        throw TranslationEngineError.missingLocalModel(pair: pair)
    }

    private func demoTranslation(for request: TranslationRequest) -> String? {
        let normalized = request.text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        let examples: [String: [LanguageOption: String]] = [
            "hello": [.spanish: "hola", .french: "bonjour", .german: "hallo", .japanese: "こんにちは"],
            "thank you": [.spanish: "gracias", .french: "merci", .german: "danke", .japanese: "ありがとうございます"],
            "good morning": [.spanish: "buenos dias", .french: "bonjour", .german: "guten Morgen", .japanese: "おはようございます"]
        ]

        return examples[normalized]?[request.targetLanguage]
    }
}

