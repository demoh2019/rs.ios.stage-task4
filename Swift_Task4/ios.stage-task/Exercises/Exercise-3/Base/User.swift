import Foundation

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct User: Equatable {
    let id: UUID
}
