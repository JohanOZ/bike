import AVFoundation
import Foundation

final class AudioPlayerService: NSObject {
    private var player: AVAudioPlayer?
    private var onFinish: (() -> Void)?

    var isPlaying: Bool {
        player?.isPlaying ?? false
    }

    var currentTime: TimeInterval {
        player?.currentTime ?? 0
    }

    var duration: TimeInterval {
        player?.duration ?? 0
    }

    func configureFinishHandler(_ handler: (() -> Void)?) {
        onFinish = handler
    }

    func loadSong(from url: URL) throws {
        player = try AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = min(max(0, time), duration)
    }
}

extension AudioPlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinish?()
    }
}
