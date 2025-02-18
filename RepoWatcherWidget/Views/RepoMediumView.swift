//
//  RepoMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Michael Martell on 2/17/25.
//

import SwiftUI
import WidgetKit

struct RepoMediumView: View {
    let repo: Repository
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int{
        calculateDaysSinceLastActivity(from: repo.pushedAt)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if #available(iOS 18.0, *) {
                        Image(uiImage: UIImage(data: repo.avatarData) ?? (UIImage(named: "avatar")!))
                            .resizable()
                            .widgetAccentedRenderingMode(.desaturated)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: UIImage(data: repo.avatarData) ?? (UIImage(named: "avatar")!))
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                    }
                    
                    Text(repo.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                        .widgetAccentable()
                }
                .padding(.bottom, 6)
                
                HStack {
                    StatLabel(value: repo.watchers, systemImageName: "star.fill")
                    StatLabel(value: repo.forks, systemImageName: "tuningfork")
                    if repo.hasIssues {
                        StatLabel(value: repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                    }
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
                    .contentTransition(.numericText())
                    .widgetAccentable()
                
                Text("days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func calculateDaysSinceLastActivity(from dateString: String) -> Int {
        let formatter = ISO8601DateFormatter()
        let lastActivityDate = formatter.date(from: dateString)
        let daysSinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityDate!, to: .now).day ?? 0
        
        return daysSinceLastActivity
    }
}

//struct RepoMediumView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            RepoMediumView(repo: MockData.repoOne)
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//                .containerBackground(.fill.tertiary, for: .widget)
//            RepoMediumView(repo: MockData.repoTwo)
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//    }
//}

#Preview(as:  .systemLarge) {
    DoubleRepoWidget()
} timeline: {
    DoubleRepoEntry(date: .now, topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    DoubleRepoEntry(date: .now, topRepo: MockData.repoTwo, bottomRepo: MockData.repoTwo)
}
