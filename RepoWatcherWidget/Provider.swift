//
//  Provider.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        // This is used for the design-time preview in Xcode
        RepoEntry(date: Date(), repo: Repository.preview, avatarImageData: Data())
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        // This is used for the widget gallery preview
        let entry = RepoEntry(date: Date(), repo: Repository.preview, avatarImageData: Data())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RepoEntry>) -> ()) {
        // Create a default timeline with fallback data in case of failure
        let fallbackEntry = RepoEntry(
            date: .now,
            repo: Repository.fallback,
            avatarImageData: UIImage(named: "avatar")?.pngData() ?? Data()
        )
        
        let fallbackTimeline = Timeline(
            entries: [fallbackEntry],
            policy: .after(Date().addingTimeInterval(43200)) // 12 hours
        )
        
        Task {
            do {
                let repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.davidsGaragePro)
                let avatarImageData = try await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl) ?? UIImage(named: "avatar")?.pngData() ?? Data()
                let entry = RepoEntry(date: .now, repo: repo, avatarImageData: avatarImageData)
                let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
                completion(fallbackTimeline) // Use fallback timeline in case of error
            }
        }
    }
}
