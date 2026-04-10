import Foundation

struct Playlist: Identifiable, Equatable {
    let id: UUID
    var name: String
    var songs: [Song]

    var totalDuration: TimeInterval {
        songs.reduce(0) { $0 + $1.duration }
    }

    var songCount: Int {
        songs.count
    }
}
