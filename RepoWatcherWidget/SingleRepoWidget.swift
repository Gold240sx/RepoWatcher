//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Michael Martell on 2/17/25.
//

import Foundation

import WidgetKit
import SwiftUI

struct SingleRepoWidget: Widget {
    let kind: String = "ContributorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleRepoProvider()) { entry in
            SingleRepoEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Contributors")
        .description("View the repo's contributors.")
        .supportedFamilies([.systemLarge])
    }
}

struct ContributorWidgetBundle: PreviewProvider {
    static var previews: some View {
        SingleRepoEntryView(entry: SingleRepoEntry(date: Date(), repo: MockData.preview))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .containerBackground(.fill.tertiary, for: .widget)
    }
}
