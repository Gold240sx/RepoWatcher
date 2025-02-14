import Foundation
import WidgetKit

enum Configuration {
    static var githubApiKey: String {
        // Try main bundle first
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let apiKey = dict["GITHUB_API_KEY"] as? String {
            return apiKey
        }
        
        // Try widget extension bundle
        if let path = Bundle(identifier: "com.michaelMartell.RepoWatcher.RepoWatcherWidget")?.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let apiKey = dict["GITHUB_API_KEY"] as? String {
            return apiKey
        }
        
        fatalError("GITHUB_API_KEY not found in Secrets.plist")
    }
} 