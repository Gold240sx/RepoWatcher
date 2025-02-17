//
//  TestRepository.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import Foundation

struct Repository {
    let name: String
    let owner: Owner
    let watchers: Int
    let openIssues: Int
    let hasIssues: Bool
    let forks: Int
    let pushedAt: String
    var avatarData: Data
    
    // Used for Xcode previews and widget gallery
    static let preview = Repository(
        name: "Preview Repo",
        owner: Owner(avatarUrl: ""),
        watchers: 999,
        openIssues: 123,
        hasIssues: true,
        forks: 45,
        pushedAt: "2025-01-13T19:48:59Z",
        avatarData: Data()
    )
    
    // Used when network requests fail
    static let fallback = Repository(
        name: "Unable to Load",
        owner: Owner(avatarUrl: ""),
        watchers: 0,
        openIssues: 0,
        hasIssues: false,
        forks: 0,
        pushedAt: "2025-02-14T00:00:00Z",
        avatarData: Data()
    )
}

extension Repository {
    struct CodingData: Decodable {
        let name: String
        let owner: Owner
        let watchers: Int
        let openIssues: Int
        let hasIssues: Bool
        let forks: Int
        let pushedAt: String
        
        var repo: Repository {
            Repository(
                name: name,
                owner: owner,
                watchers: watchers,
                openIssues: openIssues,
                hasIssues: hasIssues,
                forks: forks,
                pushedAt: pushedAt,
                avatarData: Data()
            )
        }
    }
}

struct Owner: Decodable {
    let avatarUrl: String
}
