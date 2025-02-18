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
        
        // Debug token access
        let sharedDefaults = UserDefaults.shared
        let token = sharedDefaults.string(forKey: UserDefaults.githubKey)
        print("Debug: Widget timeline - Token check")
        print("Debug: - Token exists: \(token != nil)")
        print("Debug: - Token value: \(token?.prefix(5) ?? "nil")...")
        
        // Safely unwrap repo or use default
        let repoPath = configuration.repo ?? "sallen0400/swift-news"
        let repoToShow = RepoURL.prefix + repoPath
        
        print("Debug: Attempting to fetch repo: \(repoPath)")
        
        do {
            var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
            let avatarImageData = try await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
            repo.avatarData = avatarImageData ?? Data()
            
            if context.family == .systemLarge {
                let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                var topFour = Array(contributors.prefix(4))
                
                for i in topFour.indices {
                    let avatarData = try await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                
                repo.contributors = topFour
            }
            
            let entry = SingleRepoEntry(date: .now, repo: repo)
            return Timeline(entries: [entry], policy: .after(nextUpdate))
            
        } catch {
            print("❌ Error fetching repo: \(error)")
            let entry = SingleRepoEntry(date: .now, repo: MockData.fallback)
            return Timeline(entries: [entry], policy: .after(nextUpdate))
        }
    }
}
