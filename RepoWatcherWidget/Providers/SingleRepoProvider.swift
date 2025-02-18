//
//  ContributorProvider.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/17/25.
//

import WidgetKit
import SwiftUI

struct SingleRepoProvider: IntentTimelineProvider {
    func getSnapshot(for configuration: SelectSingleRepoIntent, in context: Context, completion: @escaping @Sendable (SingleRepoEntry) -> Void) {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectSingleRepoIntent, in context: Context, completion: @escaping @Sendable (Timeline<SingleRepoEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                // Get Repo
                let repoToShow = RepoURL.prefix + configuration.repo!
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = try await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                if context.family == .systemLarge {
                    // Get Contributors
                    let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                    
                    // Filter to the top 4
                    var topFour = Array(contributors.prefix(4))
                    
                    // Download top four avatars
                    for i in topFour.indices {
                        let avatarData = try await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                        topFour[i].avatarData = avatarData ?? Data()
                    }
                    
                    repo.contributors = topFour
                }
                
                // Create Entry & timeline
                let entry = SingleRepoEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
    
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }

}
