//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Michael Martell on 2/14/25.
//

import WidgetKit
import SwiftUI

struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RepoWatcherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RepoWatcherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Repo Watcher")
        .description("Keep an eye on one or two Github repositories.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    RepoWatcherWidget()
} timeline: {
    RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
}
