//
//  NetworkManager.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let decoder = JSONDecoder()
    private let baseURL = "https://api.github.com/repos/"
    
    // Access token from configuration
    private var token: String? {
        // Check shared UserDefaults first
        if let sharedDefaults = UserDefaults(suiteName: "group.com.michaelMartell.RepoWatcher"),
           let userToken = sharedDefaults.string(forKey: "githubKey"),
           !userToken.isEmpty {
            return userToken
        }
        
        // Fall back to Secrets.plist
        return getToken()
    }
    
    private func getToken() -> String? {
        // Try main bundle first
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") {
            print("Debug: Found Secrets.plist in main bundle at: \(path)")
            if let dict = NSDictionary(contentsOfFile: path),
               let apiKey = dict["GITHUB_API_KEY"] as? String {
                return apiKey
            } else {
                print("Debug: Failed to read API key from main bundle plist")
            }
        } else {
            print("Debug: Secrets.plist not found in main bundle")
        }
        
        // Try widget extension bundle
        if let widgetBundle = Bundle(identifier: "com.michaelMartell.RepoWatcher.RepoWatcherWidget") {
            if let path = widgetBundle.path(forResource: "Secrets", ofType: "plist") {
                print("Debug: Found Secrets.plist in widget bundle at: \(path)")
                if let dict = NSDictionary(contentsOfFile: path),
                   let apiKey = dict["GITHUB_API_KEY"] as? String {
                    return apiKey
                } else {
                    print("Debug: Failed to read API key from widget bundle plist")
                }
            } else {
                print("Debug: Secrets.plist not found in widget bundle")
            }
        } else {
            print("Debug: Could not load widget bundle")
        }
        
        print("Debug: No token found in any bundle")
        return nil
    }
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getRepo(atUrl urlString: String) async throws -> Repository {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
            case 200:
                do {
                    let codingData = try decoder.decode(Repository.CodingData.self, from: data)
                    return codingData.repo
                } catch {
                    print("❌ Decoding error: \(error)")
                    throw NetworkError.invalidRepoData
                }
            case 401:
                print("⚠️ Unauthorized - API key might be missing or invalid")
                throw NetworkError.unauthorized
            case 403:
                print("⚠️ Forbidden - Check API rate limits or token permissions")
                throw NetworkError.forbidden
            case 404:
                print("⚠️ Repository not found")
                throw NetworkError.notFound
            default:
                throw NetworkError.invalidResponse
        }
    }
    
    func getContributors(atUrl urlString: String) async throws -> [Contributor] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
            case 200:
                do {
                    let codingData = try decoder.decode([Contributor.CodingData].self, from: data)
                    let contributors = codingData.map { $0.contributor}
                    return contributors
                } catch {
                    print("❌ Decoding error: \(error)")
                    throw NetworkError.invalidRepoData
                }
            case 401:
                print("⚠️ Unauthorized - API key might be missing or invalid")
                throw NetworkError.unauthorized
            case 403:
                print("⚠️ Forbidden - Check API rate limits or token permissions")
                throw NetworkError.forbidden
            case 404:
                print("⚠️ Repository not found")
                throw NetworkError.notFound
            default:
                throw NetworkError.invalidResponse
        }
    }
    
    
    func downloadImageData(from urlString: String) async throws -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }
    
    func fetchRepository(owner: String, repo: String) async throws -> Repository {
        let endpoint = baseURL + "\(owner)/\(repo)"
        
        var request = URLRequest(url: URL(string: endpoint)!)
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Debug: Adding auth header")
        } else {
            print("Debug: No token available for request")
        }
        
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
            case 200:
                do {
                    let codingData = try decoder.decode(Repository.CodingData.self, from: data)
                    return codingData.repo
                } catch {
                    print("❌ Decoding error: \(error)")
                    throw NetworkError.invalidRepoData
                }
            case 401:
                print("⚠️ Unauthorized - API key might be missing or invalid")
                throw NetworkError.unauthorized
            case 403:
                print("⚠️ Forbidden - Check API rate limits or token permissions")
                throw NetworkError.forbidden
            case 404:
                print("⚠️ Repository not found")
                throw NetworkError.notFound
            default:
                throw NetworkError.invalidResponse
        }
    }
    
}


enum NetworkError: Error {
    case invalidURL
    case invalidToken
    case invalidResponse
    case invalidRepoData
    case unauthorized
    case forbidden
    case notFound
}

enum RepoURL {
    static let monthlyWidgetFull = "https://api.github.com/repos/gold240sx/Monthly-Widget-Full"
    static let davidsGaragePro = "https://api.github.com/repos/Gold240sx/DGP_Prod"
    static let portfolio = "https://api.github.com/repos/Gold240sx/portfolio_2025"
    static let swiftNews = "https://api.github.com/repos/sallen0400/swift-news"
    static let google = "https://api.github.com/repos/google/GoogleSignIn-iOS"
}
