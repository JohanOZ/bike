//
//  AudioPlayerService.swift
//  Bike
//
//  Created by Johan Olea on 10/04/26.
//


import AVFoundation
import Combine
import Observation

@Observable
final class AudioPlayerService {
    private var queuePlayer: AVQueuePlayer?
    private var timeObserverToken: Any?
    
    // Estado reactivo
    var isPlaying: Bool = false
    var currentSong: Song?
    var queue: [Song] = []
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var isLoading: Bool = false
    
    // MARK: - Public API
    func play(_ songs: [Song], from index: Int = 0) {
        guard !songs.isEmpty else { return }
        queue = songs
        isLoading = true
        
        let items = songs.map { AVPlayerItem(url: $0.fileURL) }
        queuePlayer = AVQueuePlayer(items: items)
        
        // Posicionar en el índice solicitado
        if index < items.count {
            queuePlayer?.advanceToItem(at: index)
        }
        
        setupTimeObserver()
        observePlayerState()
        
        queuePlayer?.play()
        currentSong = queue.indices.contains(index) ? queue[index] : nil
        isLoading = false
        isPlaying = true
    }
    
    func togglePlayPause() {
        guard let player = queuePlayer else { return }
        if player.rate == 0 {
            player.play()
            isPlaying = true
        } else {
            player.pause()
            isPlaying = false
        }
    }
    
    func next() { queuePlayer?.advanceToNextItem() }
    func previous() { queuePlayer?.advanceToItem(at: 0) }
    
    func seek(to time: TimeInterval) {
        let target = CMTime(seconds: time, preferredTimescale: 1)
        queuePlayer?.seek(to: target, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    // MARK: - Private
    private func setupTimeObserver() {
        removeTimeObserver()
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = queuePlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
    
    private func removeTimeObserver() {
        if let token = timeObserverToken {
            queuePlayer?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    private func observePlayerState() {
        // Actualiza duración y cambia de canción automáticamente
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self, let currentItem = self.queuePlayer?.currentItem,
                  let index = self.queuePlayer?.items().firstIndex(of: currentItem),
                  index + 1 < self.queue.count else { return }
            self.currentSong = self.queue[index + 1]
        }
        
        // Actualiza duración cuando cambia el ítem
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemNewAccessLogEntry,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.duration = self?.queuePlayer?.currentItem?.duration.seconds ?? 0
        }
    }
    
    deinit {
        removeTimeObserver()
        NotificationCenter.default.removeObserver(self)
    }
}