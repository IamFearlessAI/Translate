# Translation Models

Place local translation model bundles here.

The app expects a model-provider layer that can resolve a language pair such as:

```text
en-es
ja-en
auto-fr
```

Suggested production options:

- Core ML sequence-to-sequence models packaged per language pair.
- A small local LLM or encoder-decoder model converted to Core ML, if it fits device memory.
- Vendor on-device translation SDKs that permit offline use and iOS redistribution.

The sample `LocalModelTranslationEngine` is intentionally conservative: it provides the async API and returns a clear "model unavailable" result until real local models are added.

