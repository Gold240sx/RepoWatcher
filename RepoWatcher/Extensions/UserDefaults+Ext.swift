//
//  UserDefaults+Ext.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/18/25.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.com.michaelMartell.RepoWatcher") ?? .standard
    }
    
    static let repoKey = "repos"
    static let githubKey = "githubKey"
}

enum UserDefaultsError: Error {
    case failedToSetValue
    case failedToGetValue
    case retrievalFailed
}
