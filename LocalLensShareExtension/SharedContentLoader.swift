import Foundation
import UIKit
import UniformTypeIdentifiers

enum SharedContentError: LocalizedError {
    case noSupportedContent
    case invalidImage

    var errorDescription: String? {
        switch self {
        case .noSupportedContent:
            return "Share selected text or an image with readable text."
        case .invalidImage:
            return "The shared image could not be read."
        }
    }
}

final class SharedContentLoader {
    private let context: NSExtensionContext?
    private let ocrService = OCRService()

    init(context: NSExtensionContext?) {
        self.context = context
    }

    func loadTextOrRecognizeImage() async throws -> String {
        let providers = context?.inputItems
            .compactMap { $0 as? NSExtensionItem }
            .flatMap { $0.attachments ?? [] } ?? []

        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                return try await loadString(from: provider)
            }
        }

        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                let image = try await loadImage(from: provider)
                guard let cgImage = image.cgImage else { throw SharedContentError.invalidImage }
                return try await ocrService.recognizeText(in: cgImage)
            }
        }

        throw SharedContentError.noSupportedContent
    }

    private func loadString(from provider: NSItemProvider) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { item, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                if let string = item as? String {
                    continuation.resume(returning: string)
                } else if let data = item as? Data, let string = String(data: data, encoding: .utf8) {
                    continuation.resume(returning: string)
                } else {
                    continuation.resume(throwing: SharedContentError.noSupportedContent)
                }
            }
        }
    }

    private func loadImage(from provider: NSItemProvider) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                if let image = item as? UIImage {
                    continuation.resume(returning: image)
                } else if let url = item as? URL, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    continuation.resume(returning: image)
                } else if let data = item as? Data, let image = UIImage(data: data) {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: SharedContentError.invalidImage)
                }
            }
        }
    }
}

