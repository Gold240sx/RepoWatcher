//
//  ContributorView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Michael Martell on 2/17/25.
//

import SwiftUI
import WidgetKit

struct ContributorEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct ContributorEntryView : View {
    var entry: ContributorEntry

    var body: some View {
        VStack {
            RepoMediumView(repo:  entry.repo)
            ContributorMediumView(repo: entry.repo)
        }
    }
}
