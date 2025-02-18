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
    var entry: SingleRepoEntry

    var body: some View {
        VStack {
            RepoMediumView(repo:  entry.repo)
            Spacer().frame(height: 24)
            ContributorMediumView(repo: entry.repo)
        }
    }
}
