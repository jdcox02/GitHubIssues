//
//  GitHubClient.swift
//  Project3
//
//  Created by Joshua Cox on 1/23/24.
//

import UIKit

import Foundation

// MARK: - Models

/// Represents a GitHub issue
struct GitHubIssue: Codable {
    let title: String?
    let createdAt: String
    let body: String?
    let state: String
    let user: GitHubUser?
}

/// Represents a GitHub user
struct GitHubUser: Codable {
    let login: String
}



class GitHubClient {
    
    // MARK: - Fetching Issues
    
    /// Fetches open issues from the GitHub API
    static func fetchOpenIssues(completion: @escaping ([GitHubIssue]?, Error?) -> Void) {
    
    // Set the URL ( we are using Alamaofire for this project)
    let url = URL(string: "https://api.github.com/repos/Alamofire/Alamofire/issues?state=open")!
    
    // Create a data task
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        
    // Check for errors or missing data
      guard let data = data, error == nil else {
        // If we are missing data, send back no data with an error
        DispatchQueue.main.async { completion(nil, error) }
        return
      }
      
      // Decode the JSON data to an array of GithubIssue
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let issues = try decoder.decode([GitHubIssue].self, from: data)
        DispatchQueue.main.async { completion(issues, nil) }

      } catch (let parsingError) {
        DispatchQueue.main.async { completion(nil, parsingError) }
      }
    }
    
    task.resume()
  }
    
    /// Fetches closed issues from the GitHub API
    static func fetchClosedIssues(completion: @escaping ([GitHubIssue]?, Error?) -> Void) {
    
    // Set the URL ( we are using Alamaofire for this project)
    let url = URL(string: "https://api.github.com/repos/Alamofire/Alamofire/issues?state=closed")!
    
    // Create and start a data task to fetch the issues
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
    // Check for errors or missing data
      guard let data = data, error == nil else {
          DispatchQueue.main.async { completion(nil, error) }
        return
      }
      
      // Decode the JSON data to an array of GitHubIssue
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let issues = try decoder.decode([GitHubIssue].self, from: data)
        DispatchQueue.main.async { completion(issues, nil) }

      } catch (let parsingError) {
        DispatchQueue.main.async { completion(nil, parsingError) }
      }
    }
    
    task.resume()
  }
}
