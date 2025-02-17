//
//  Provider.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import WidgetKit
import SwiftUI

struct CompactRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        // This is used for the design-time preview in Xcode
        RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        // This is used for the widget gallery preview
        let entry = RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RepoEntry>) -> ()) {
        // Add debug logging at the start
        print("Debug: Main bundle path - \(Bundle.main.bundlePath)")
        print("Debug: Widget bundle path - \(Bundle(identifier: "com.michaelMartell.RepoWatcher.RepoWatcherWidget")?.bundlePath ?? "not found")")
        
        if let widgetBundle = Bundle(identifier: "com.michaelMartell.RepoWatcher.RepoWatcherWidget") {
            print("Debug: Files in widget bundle - \(String(describing: try? FileManager.default.contentsOfDirectory(atPath: widgetBundle.bundlePath)))")
        }
        
        // Create a default timeline with fallback data in case of failure
        let fallbackEntry = RepoEntry(
            date: .now,
            repo: MockData.repoOne,
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
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.davidsGaragePro)
                let avatarImageData = try await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl) ?? UIImage(named: "avatar")?.pngData() ?? Data()
                repo.avatarData = avatarImageData

                // Get Bottom Repo if in Large Widget
                var bottomRepo: Repository?

                if context.family == .systemLarge {
                    bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.portfolio)
                    let avatarImageData = try await NetworkManager.shared.downloadImageData(from: bottomRepo!.owner.avatarUrl)
                    bottomRepo!.avatarData = avatarImageData ?? Data()
                }

                // Create Entry & Timeline
                let entry = RepoEntry(date: .now, repo: repo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
                completion(fallbackTimeline) // Use fallback timeline in case of error
            }
        }
    }
}
