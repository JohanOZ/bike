# Bike 🚲
**A High-Fidelity Personal Music Player for iOS**

**Bike** is a native iOS application designed for users who demand total control over their music library. The goal is simple: a premium, ad-free, and subscription-free experience, powered exclusively by your own local files (MP3, FLAC, ALAC).

The name stems from the idea of "freedom of movement" and simplicity: you are the one pedaling and choosing the path for your music.

---

## 🚀 Key Features
* **Zero Ads:** 100% offline playback of local files. No interruptions, no tracking.
* **Hi-Fi Ready:** Optimized for lossless formats (FLAC/ALAC) to leverage the iPhone's internal audio hardware and DACs.
* **Native Integration:** Direct access via the iOS **Files** app; just drag and drop your music.
* **Seamless Control:** Full support for Lock Screen controls, Control Center, and Bluetooth peripherals.
* **Total Privacy:** No cloud sync, no data collection—just you and your music.

## 🛠️ Technical Stack
* **Language:** Swift 5.x
* **Interface:** SwiftUI (Declarative UI)
* **Architecture:** MVVM (Model-View-ViewModel)
* **Audio Engine:** `AVFoundation` for playback & `AVAudioSession` for system-level audio management.
* **Persistence:** Metadata management via native **ID3 Tag** parsing.

## 🏗️ Architecture & Development
As a developer with a background in **Java and Spring Boot**, I've designed **Bike** with robust software engineering principles:
* **Separation of Concerns:** Business logic (Audio Engine) is decoupled from the UI layer.
* **Reactive State:** Utilizing `@StateObject` and `@Published` to ensure the UI stays in perfect sync with the audio buffer.
* **Hardware Optimization:** Configuring `AVAudioSession` categories to ensure high-priority playback and background audio persistence.

## 🗺️ Roadmap
* [ ] **Advanced EQ:** 10-band manual equalizer using `AVAudioUnitEQ`.
* [ ] **Metadata Scraper:** Automatic album art and artist info retrieval from local tags.
* [ ] **Waveform Visualization:** Real-time audio spectrum analysis.
* [ ] **Smart Playlists:** Automatic categorization based on genre and play count.
