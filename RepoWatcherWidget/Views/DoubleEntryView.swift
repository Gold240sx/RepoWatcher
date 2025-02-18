//
//  EnryView.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import SwiftUI
import WidgetKit

struct DoubleRepoEntry: TimelineEntry {
    let date: Date
    let topRepo: Repository
    let bottomRepo: Repository
}

struct DoubleRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: DoubleRepoProvider.Entry

    
    var body: some View {
        VStack(spacing: 36) {
            RepoMediumView(repo: entry.topRepo)
                .containerBackground(.fill.tertiary, for: .widget)
            RepoMediumView(repo: entry.bottomRepo)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
