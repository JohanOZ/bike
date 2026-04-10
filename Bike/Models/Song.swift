import Foundation

struct Song: Identifiable, Equatable {
    let id: UUID
    let title: String
    let artist: String
    let album: String
    let duration: TimeInterval
    let fileURL: URL
    let artworkURL: URL?

    init(
        id: UUID = UUID(),
        title: String,
        artist: String,
        album: String,
        duration: TimeInterval = 0,
        fileURL: URL,
        artworkURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.duration = duration
        self.fileURL = fileURL
        self.artworkURL = artworkURL
    }

    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
