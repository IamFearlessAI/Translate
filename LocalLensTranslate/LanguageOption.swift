import Foundation

enum LanguageOption: String, CaseIterable, Identifiable, Codable, Hashable {
    case auto
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case dutch = "nl"
    case russian = "ru"
    case ukrainian = "uk"
    case arabic = "ar"
    case hebrew = "he"
    case hindi = "hi"
    case bengali = "bn"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case japanese = "ja"
    case korean = "ko"
    case vietnamese = "vi"
    case thai = "th"
    case turkish = "tr"
    case polish = "pl"
    case swedish = "sv"

    var id: String { rawValue }

    var name: String {
        switch self {
        case .auto: return "Auto"
        case .english: return "English"
        case .spanish: return "Spanish"
        case .french: return "French"
        case .german: return "German"
        case .italian: return "Italian"
        case .portuguese: return "Portuguese"
        case .dutch: return "Dutch"
        case .russian: return "Russian"
        case .ukrainian: return "Ukrainian"
        case .arabic: return "Arabic"
        case .hebrew: return "Hebrew"
        case .hindi: return "Hindi"
        case .bengali: return "Bengali"
        case .chineseSimplified: return "Chinese Simplified"
        case .chineseTraditional: return "Chinese Traditional"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .vietnamese: return "Vietnamese"
        case .thai: return "Thai"
        case .turkish: return "Turkish"
        case .polish: return "Polish"
        case .swedish: return "Swedish"
        }
    }

    static var translatableCases: [LanguageOption] {
        allCases.filter { $0 != .auto }
    }
}

