//
//  IntentHandler.swift
//  RepoWatcherIntents
//
//  Created by Michael Martell on 2/18/25.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the communication layer between the app and the widget.
        // This is the default implementation
        
        return self
    }
    
}

extension IntentHandler: SelectSingleRepoIntentHandling {
    func provideRepoOptionsCollection(for intent: SelectSingleRepoIntent) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retrievalFailed
        }
        
        return INObjectCollection(items: repos as [NSString])
    }
    
    func defaultRepo(for intent: SelectSingleRepoIntent) -> String? {
        return "apple/swift"
    }
}

extension IntentHandler: SelectTwoReposIntentHandling {
    
    func provideTopRepoOptionsCollection(for intent: SelectTwoReposIntent) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retrievalFailed
        }
        
        return INObjectCollection(items: repos as [NSString])
    }
    
    func provideBottomRepoOptionsCollection(for intent: SelectTwoReposIntent) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retrievalFailed
        }
        
        return INObjectCollection(items: repos as [NSString])
    }
    
    func defaultTopRepo(for intent: SelectTwoReposIntent) -> String? {
        return "apple/swift"
    }
    
    func defaultBottomRepo(for intent: SelectTwoReposIntent) -> String? {
        return "google/firebase"
    }
}
