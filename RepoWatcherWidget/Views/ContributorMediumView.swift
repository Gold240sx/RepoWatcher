//
//  ContributorMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Michael Martell on 2/17/25.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
    let repo: Repository
    var body: some View {
        VStack {
            HStack {
                Text("Top Contributors")
                    .font(.caption).bold()
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .leading, spacing: 20) {
                ForEach(repo.contributors) { contributor in
                    HStack {
                        if #available(iOS 18.0, *) {
                            Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                                .resizable()
                                .widgetAccentedRenderingMode(.desaturated)
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
 
                        } else {
                            Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                                .resizable()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                        }
                        
                        VStack (alignment: .leading) {
                            
                            Text(contributor.login)
                                .font(.caption)
                                .minimumScaleFactor(0.7)

                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .id(repo.name)
                                .transition(.push(from: .trailing))
                        }
                        .widgetAccentable()
                    }
                }
            }
            
            if repo.contributors.count < 3 {
                Spacer()
                    .frame(height: 20)
            }
        }
    }
}

//struct ContributorMediumView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContributorMediumView(repo: MockData.repoOne)
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}

#Preview(as: .systemMedium) {
    ContributorWidget()
} timeline: {
    ContributorEntry(date: .now, repo: MockData.repoOne)
}
