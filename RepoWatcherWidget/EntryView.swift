//
//  EnryView.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import SwiftUI
import WidgetKit

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct RepoWatcherWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
                .containerBackground(.fill.tertiary, for: .widget)
        case .systemLarge: VStack (spacing: 36) {
            RepoMediumView(repo: entry.repo)
                .containerBackground(.fill.tertiary, for: .widget)
            RepoMediumView(repo: entry.repo)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        
        case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
        //repo: entry.repo, avatarImageData: entry.avatarImageData
    }
}
