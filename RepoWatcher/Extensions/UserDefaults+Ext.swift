//
//  UserDefaults+Ext.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/18/25.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.com.michaelmartell.RepoWatcher")!
    }
    
    static let repoKey = "repos"
}
