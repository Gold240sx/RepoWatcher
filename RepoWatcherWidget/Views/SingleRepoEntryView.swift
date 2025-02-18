//
//  ContributorView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Michael Martell on 2/17/25.
//

import SwiftUI
import WidgetKit

struct SingleRepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct SingleRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry

    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo:  entry.repo)
        case .systemLarge:
            VStack {
                RepoMediumView(repo: entry.repo)
                Spacer().frame(height: 24)
                ContributorMediumView(repo: entry.repo)
            }
        case
            .systemSmall,
            .systemExtraLarge,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}
