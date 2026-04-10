import Combine
import Foundation
import SwiftUI

@MainActor
final class PlayerViewModel: ObservableObject {
    @Published private(set) var currentSong: Song?
    @Published private(set) var isPlaying = false
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0
    @Published private(set) var errorMessage: String?

    private let audioPlayerService: AudioPlayerService
    private var timer: Timer?

    init() {
        self.audioPlayerService = AudioPlayerService()
        self.audioPlayerService.configureFinishHandler { [weak self] in
            guard let self else { return }
            self.isPlaying = false
            self.currentTime = 0
        }
    }

    init(audioPlayerService: AudioPlayerService) {
        self.audioPlayerService = audioPlayerService
        self.audioPlayerService.configureFinishHandler { [weak self] in
            guard let self else { return }
            self.isPlaying = false
            self.currentTime = 0
        }
    }

    deinit {
        timer?.invalidate()
    }

    func loadDemoSong() {
        guard let songURL = bundledMP3URL() else {
            errorMessage = "Agrega cualquier archivo .mp3 a Bike/Resources y al target Bike para probar la reproducción."
            return
        }

        let song = Song(
            title: songURL.deletingPathExtension().lastPathComponent,
            artist: "Bike",
            album: "Local Files",
            fileURL: songURL
        )

        load(song: song)
    }

    func load(song: Song) {
        do {
            try audioPlayerService.loadSong(from: song.fileURL)
            currentSong = song
            duration = audioPlayerService.duration
            currentTime = audioPlayerService.currentTime
            errorMessage = nil
        } catch {
            errorMessage = "No se pudo cargar el audio local: \(error.localizedDescription)"
        }
    }

    func togglePlayback() {
        guard currentSong != nil else {
            loadDemoSong()
            if currentSong == nil { return }
            return togglePlayback()
        }

        if isPlaying {
            audioPlayerService.pause()
            stopTimer()
        } else {
            audioPlayerService.play()
            startTimer()
        }

        syncState()
    }

    func seek(to time: TimeInterval) {
        audioPlayerService.seek(to: time)
        syncState()
    }

    var progress: Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.syncState()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func syncState() {
        isPlaying = audioPlayerService.isPlaying
        currentTime = audioPlayerService.currentTime
        duration = audioPlayerService.duration
    }

    private func bundledMP3URL() -> URL? {
        if let resourcesURL = Bundle.main.resourceURL {
            let resourceMP3s = (try? FileManager.default.contentsOfDirectory(
                at: resourcesURL.appendingPathComponent("Resources"),
                includingPropertiesForKeys: nil
            ))?
                .filter { $0.pathExtension.lowercased() == "mp3" }
                .sorted { $0.lastPathComponent < $1.lastPathComponent }

            if let firstResourceMP3 = resourceMP3s?.first {
                return firstResourceMP3
            }
        }

        let bundledMP3s = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)?
            .sorted { $0.lastPathComponent < $1.lastPathComponent }

        return bundledMP3s?.first
    }
}
