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
    let avatarImageData: Data
}

struct RepoWatcherWidgetEntryView : View {
    var entry: Provider.Entry
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int{
        calculateDaysSinceLastActivity(from: entry.repo.pushedAt)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: (UIImage(data: entry.avatarImageData) ?? UIImage(named: "avatar")!))
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    Text(entry.repo.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                
                HStack {
                    StatLabel(value: entry.repo.watchers, systemImageName: "star.fill")
                    StatLabel(value: entry.repo.forks, systemImageName: "tuningfork")
                    StatLabel(value: entry.repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                }
            }
            
            Spacer()
            
            VStack {
                Text("\(daysSinceLastActivity)")
                    .bold()
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(daysSinceLastActivity > 50 ? .pink : .green)
                
                Text("days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    func calculateDaysSinceLastActivity(from dateString: String) -> Int {
        let formatter = ISO8601DateFormatter()
        let lastActivityDate = formatter.date(from: dateString)
        let daysSinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityDate!, to: .now).day ?? 0
        
        return daysSinceLastActivity
    }
}
