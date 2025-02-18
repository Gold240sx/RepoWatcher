//
//  ContributorProvider.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/17/25.
//

import WidgetKit
import SwiftUI

struct SingleRepoProvider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    func snapshot(for configuration: SelectSingleRepo, in context: Context) async -> SingleRepoEntry {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        return entry
    }
    
    func timeline(for configuration: SelectSingleRepo, in context: Context) async -> Timeline<SingleRepoEntry> {
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
            return timeline
        } catch {
            print("❌ Error - \(error.localizedDescription)")
            return Timeline(entries: [], policy: .after(nextUpdate)) // [entry] if you wanted to return errors.
        }
    }
}
