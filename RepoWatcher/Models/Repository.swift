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
