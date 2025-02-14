import Foundation

enum Configuration {
    static var githubApiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["GITHUB_API_KEY"] as? String else {
            fatalError("GITHUB_API_KEY not found in Secrets.plist")
        }
        return apiKey
    }
} 