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
    let kind: String = "SingleRepoWidget"

    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: SingleRepoProvider()) { entry in
//            SingleRepoEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//        .configurationDisplayName("Single Repo")
//        .description("Track a single Repository")
//        .supportedFamilies([.systemMedium,.systemLarge])
        IntentConfiguration(kind: kind, intent: SelectSingleRepoIntent.self, provider: SingleRepoProvider()){ entry in
            SingleRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Single Repo")
        .description("Track a single Repository")
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}

struct SingleRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        SingleRepoEntryView(entry: SingleRepoEntry(date: Date(), repo: MockData.preview))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .containerBackground(.fill.tertiary, for: .widget)
    }
}
