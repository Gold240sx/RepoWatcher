//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Michael Martell on 2/14/25.
//

import WidgetKit
import SwiftUI

struct DoubleRepoWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DoubleRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                DoubleRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DoubleRepoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Repo Watcher")
        .description("Keep an eye on two Github repositories.")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    DoubleRepoWidget()
} timeline: {
    DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
}
