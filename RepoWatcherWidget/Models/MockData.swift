//
//  MockData.swift
//  RepoWatcherWidgetExtension
//
//  Created by Michael Martell on 2/17/25.
//

import Foundation

struct MockData {
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
    
    static let repoOne = Repository(
        name: "Repository One",
        owner: Owner(avatarUrl: ""),
        watchers: 999,
        openIssues: 123,
        hasIssues: true,
        forks: 45,
        pushedAt: "2025-01-13T19:48:59Z",
        avatarData: Data(),
        contributors: [
            Contributor(
                login: "Gold240sx",
                avatarUrl: "",
                contributions: 23,
                avatarData: Data()
            ),
            Contributor(
                login: "RainDash3",
                avatarUrl: "",
                contributions: 16,
                avatarData: Data()
            ),
            Contributor(
                login: "RedRobin",
                avatarUrl: "",
                contributions: 2,
                avatarData: Data()
            ),
            Contributor(
                login: "EddyHall",
                avatarUrl: "",
                contributions: 38,
                avatarData: Data()
            )
        ]
    )
    
    static let repoTwo = Repository(
        name: "Repository Two",
        owner: Owner(avatarUrl: ""),
        watchers: 0,
        openIssues: 0,
        hasIssues: false,
        forks: 0,
        pushedAt: "2024-02-14T00:00:00Z",
        avatarData: Data()
    )
}
