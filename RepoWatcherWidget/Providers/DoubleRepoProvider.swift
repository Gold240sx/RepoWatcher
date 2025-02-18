//
//  Provider.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import WidgetKit
import SwiftUI

struct DoubleRepoProvider: IntentTimelineProvider {
    func getSnapshot(for configuration: SelectTwoReposIntent, in context: Context, completion: @escaping @Sendable (DoubleRepoEntry) -> Void) {
        // This is used for the widget gallery preview
        let entry = DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectTwoReposIntent, in context: Context, completion: @escaping @Sendable (Timeline<DoubleRepoEntry>) -> Void) {
        // Add debug logging at the start
        print("Debug: Main bundle path - \(Bundle.main.bundlePath)")
        print("Debug: Widget bundle path - \(Bundle(identifier: "com.michaelMartell.RepoWatcher.RepoWatcherWidget")?.bundlePath ?? "not found")")
        
        if let widgetBundle = Bundle(identifier: "com.michaelMartell.RepoWatcher.RepoWatcherWidget") {
            print("Debug: Files in widget bundle - \(String(describing: try? FileManager.default.contentsOfDirectory(atPath: widgetBundle.bundlePath)))")
        }
        
        // Create a default timeline with fallback data in case of failure
        let fallbackEntry = DoubleRepoEntry(
            date: .now,
            topRepo: MockData.repoOne,
            bottomRepo: MockData.repoTwo
        )
        
        let fallbackTimeline = Timeline(
            entries: [fallbackEntry],
            policy: .after(Date().addingTimeInterval(43200)) // 12 hours
        )
        
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds

            do {
                // Get Top Repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.prefix + configuration.topRepo!)
                let topAvatarImageData = try await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl) ?? UIImage(named: "avatar")?.pngData() ?? Data()
                repo.avatarData = topAvatarImageData

                // Get Bottom Repo
                var bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.prefix + configuration.bottomRepo!)
                let bottomAvatarImageData = try await NetworkManager.shared.downloadImageData(from: bottomRepo.owner.avatarUrl)
                bottomRepo.avatarData = bottomAvatarImageData ?? Data()

                // Create Entry & Timeline
                let entry = DoubleRepoEntry(date: .now, topRepo: repo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
                completion(fallbackTimeline) // Use fallback timeline in case of error
            }
        }
    }
    
    func placeholder(in context: Context) -> DoubleRepoEntry {
        // This is used for the design-time preview in Xcode
        DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }
}
