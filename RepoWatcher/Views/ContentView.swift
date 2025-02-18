//
//  ContentView.swift
//  RepoWatcher
//
//  Created by Michael Martell on 2/14/25.
//



import SwiftUI
import Foundation

struct ContentView: View {
    @State private var newRepo = ""
    @State private var repos: [String] = []
    @AppStorage("githubKey", store: UserDefaults.shared) private var githubKey = ""
    @State private var showingTokenSheet = false
    
    // Initialize with value from Secrets.plist
    init() {
        if let secretsToken = getToken(),
           UserDefaults.standard.string(forKey: "githubKey") == nil {
            // Only set if UserDefaults is empty
            UserDefaults.standard.set(secretsToken, forKey: "githubKey")
        }
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
    
    private func saveRepo(_ repo: String) {
        if !repos.contains(repo) && !repo.isEmpty {
            repos.append(repo)
            UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
            newRepo = ""
        }
    }
    
    private func deleteRepo(_ repo: String) {
        if repos.count > 1 {
            repos.removeAll { $0 == repo }
            UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // GitHub Token Button
                HStack {
                    Spacer() // This pushes the button to the right
                    Button {
                        showingTokenSheet = true
                    } label: {
                        HStack {
                            Image(systemName: githubKey.isEmpty ? "key" : "checkmark.shield.fill")
                                .foregroundColor(githubKey.isEmpty ? .blue : .green)
                            Text(githubKey.isEmpty ? 
                                "Accessing a private repo? Add API key" :
                                "Github API key set")
                                .font(.callout)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 15)

                Text("Add a new repo")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                HStack {
                    TextField("Ex. sallen0400/swift-news", text: $newRepo)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    Button {
                        saveRepo(newRepo)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Saved Repos")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    List(repos, id: \.self) { repo in
                        Text(repo)
                            .swipeActions {
                                Button("Delete") {
                                    if repos.count > 1 {
                                        repos.removeAll { $0 == repo}
                                        UserDefaults.shared.set("repos", forKey: UserDefaults.repoKey)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle("Repo List")
            .sheet(isPresented: $showingTokenSheet) {
                TokenInputSheet(githubKey: $githubKey, isPresented: $showingTokenSheet)
            }
            .onAppear {
                UserDefaults.verifySharedAccess()
                guard let retrievedRepos = UserDefaults.shared.array(forKey: UserDefaults.repoKey) as? [String] else {
                    let defaultValues = ["sallen0400/swift-news"]
                    UserDefaults.shared.set(defaultValues, forKey: UserDefaults.repoKey)
                    repos = defaultValues
                    return
                }
                guard let retrievedGithubKey = UserDefaults.shared.string(forKey: UserDefaults.githubKey) else {
                    return
                }
                
                repos = retrievedRepos
                githubKey = retrievedGithubKey
            }
        }
    }
}

struct TokenInputSheet: View {
    @Binding var githubKey: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Github Access Token")
                    .font(.headline)
                
                Text("Provide your Github access token to access your private repositories as well as any public ones")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("Github Access Token", text: $githubKey)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationBarItems(
                trailing: Button("Done") {
                    isPresented = false
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
