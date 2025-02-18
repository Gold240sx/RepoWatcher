//
//  StatLabelView.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import SwiftUI

struct StatLabel: View {
    
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
                .contentTransition(.numericText())
                .widgetAccentable()
        } icon: {
            Image(systemName: systemImageName)
                .foregroundStyle(.green)
        }
        .fontWeight(.medium)
    }
}
