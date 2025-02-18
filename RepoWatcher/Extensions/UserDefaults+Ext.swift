//
//  UserDefaults+Ext.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/18/25.
//

import Foundation

extension UserDefaults {
    private static let suiteName = "group.com.michaelMartell.RepoWatcher"
    
    static var shared: UserDefaults {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            print("⚠️ Failed to access shared defaults with suite: \(suiteName)")
            return .standard
        }
        print("Debug: Accessed shared defaults with suite: \(suiteName)")
        return defaults
    }
    
    static let repoKey = "repos"
    static let githubKey = "githubKey"
    
    // Helper method to verify setup
    static func verifySharedAccess() {
        let defaults = UserDefaults.shared
        print("Debug: Shared UserDefaults verification:")
        print("Debug: - Can access token: \(defaults.string(forKey: githubKey) != nil)")
        print("Debug: - Can access repos: \(defaults.array(forKey: repoKey) != nil)")
    }
}

enum UserDefaultsError: Error {
    case failedToSetValue
    case failedToGetValue
    case retrievalFailed
}
