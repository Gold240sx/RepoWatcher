//
//  RepoWatcherWidgetBundle.swift
//  RepoWatcherWidget
//
//  Created by Michael Martell on 2/14/25.
//

import WidgetKit
import SwiftUI

@main
struct RepoWatcherWidgetBundle: WidgetBundle {
    var body: some Widget {
        SingleRepoWidget()
        DoubleRepoWidget()
    }
}
