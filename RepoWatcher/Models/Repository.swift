//
//  TestRepository.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let owner: Owner
    let watchers: Int
    let openIssues: Int
    let hasIssues: Bool
    let forks: Int
    let pushedAt: String
    
    // Used for Xcode previews and widget gallery
    static let preview = Repository(
        name: "Preview Repo",
        owner: Owner(avatarUrl: ""),
        watchers: 999,
        openIssues: 123,
        hasIssues: true,
        forks: 45,
        pushedAt: "2025-01-13T19:48:59Z"
    )
    
    // Used when network requests fail
    static let fallback = Repository(
        name: "Unable to Load",
        owner: Owner(avatarUrl: ""),
        watchers: 0,
        openIssues: 0,
        hasIssues: false,
        forks: 0,
        pushedAt: "2025-02-14T00:00:00Z"
    )
}

struct Owner: Decodable {
    let avatarUrl: String
}
