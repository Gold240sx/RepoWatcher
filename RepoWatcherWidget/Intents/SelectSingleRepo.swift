//
//  SelectSingleRepo.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/18/25.
//

import Foundation
import AppIntents

struct SelectSingleRepo: AppIntent, WidgetConfigurationIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "SelectSingleRepoIntent"

    static var title: LocalizedStringResource = "Select Single Repo"
    static var description = IntentDescription("Choose a repository to watch")

    @Parameter(title: "Repo", optionsProvider: RepoOptionsProvider())
    var repo: String?

    struct RepoOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else { throw UserDefaultsError.retrievalFailed }
            return repos
        }
        
        func defaultRepo(for intent: SelectSingleRepo) -> String? { return "apple/swift" }
    }
}
