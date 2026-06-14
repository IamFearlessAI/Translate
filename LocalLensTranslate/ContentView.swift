import PhotosUI
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: TranslatorViewModel
    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                languageControls

                VStack(alignment: .leading, spacing: 8) {
                    Text("Source")
                        .font(.headline)
                    TextEditor(text: $model.sourceText)
                        .frame(minHeight: 150)
                        .padding(8)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                HStack {
                    Button {
                        Task { await model.translateSourceText() }
                    } label: {
                        Label("Translate", systemImage: "arrow.left.arrow.right")
                    }
                    .buttonStyle(.borderedProminent)

                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label("Image OCR", systemImage: "text.viewfinder")
                    }
                    .buttonStyle(.bordered)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Translation")
                        .font(.headline)
                    ScrollView {
                        Text(model.translatedText.isEmpty ? "Translation appears here." : model.translatedText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                            .padding(12)
                    }
                    .frame(minHeight: 150)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                if let message = model.statusMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .navigationTitle("LocalLens")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        model.swapLanguages()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .accessibilityLabel("Swap languages")
                }
            }
            .onChange(of: selectedPhoto) { _, item in
                Task { await model.extractText(from: item) }
            }
        }
    }

    private var languageControls: some View {
        HStack(spacing: 12) {
            Picker("From", selection: $model.sourceLanguage) {
                ForEach(LanguageOption.allCases) { language in
                    Text(language.name).tag(language)
                }
            }

            Picker("To", selection: $model.targetLanguage) {
                ForEach(LanguageOption.translatableCases) { language in
                    Text(language.name).tag(language)
                }
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    ContentView()
        .environmentObject(TranslatorViewModel())
}

