//
//  OpenIssuesViewController.swift
//  GitHubIssues
//
//  Created by Joshua Cox on 1/21/24.
//

import UIKit


//ViewController responsible for displaying a list of open GitHub issues.
class OpenIssuesViewController: UITableViewController {
    
    // MARK: - Properties
    
    /// Array to hold the list of open issues fetched from Github
    var openIssuesList: [GitHubIssue] = []
    
    /// IndexPath of the currently selected row in the table view
    var selectedIndexPath: IndexPath?
    
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch open issues when the view is about to appear.
        self.getOpenIssues()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure pull-to-refresh control for iOS 10.0 and later
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self, action: #selector(refreshIssues(sender:)), for: .valueChanged)
            self.tableView.refreshControl = refreshControl
        }
    }
    
        
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections in the table view.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Return the number of rows in the section (number of open issues).
        self.selectedIndexPath = indexPath
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section (number of open issues).
        return openIssuesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell and configure it with issue data.
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenIssueCell", for: indexPath) as! IssueTableViewCell
        let title = openIssuesList[indexPath.row].title!
        let username = openIssuesList[indexPath.row].user!.login
        cell.issueLabel.text = "\(title)"
        cell.username.text = "@\(username)"
        
        // Additional cell configuration can be done here.
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the height for each row in the table view
        return 80
    }
    
    
    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Prepare for segue to IssueDetailViewController.
        guard let selectedPath = tableView.indexPathForSelectedRow else {
            print("Invalid index path")
            return
        }
        
        // Get the destination view controller and configure it with selected issue details.
        let dvc = segue.destination as! IssueDetailViewController
        
        //sending issue title text
        if let title = openIssuesList[selectedPath.row].title {
            dvc.incomingIssueTitle = "\(title)"
        } else {
            dvc.incomingIssueTitle = ""
        }
        
        //sending author text
        let author = "\(openIssuesList[selectedPath.row].user!.login)"
        dvc.incomingAuthor = "@\(author)"
        
        //sending issue body text
        if let body = openIssuesList[selectedPath.row].body {
            dvc.incomingBody = "\(body)"
        } else {
            dvc.incomingBody = ""
        }
        
        
        //sending date text
        let date = openIssuesList[selectedPath.row].createdAt
        dvc.incomingDate = "\(date)"
        print(date)
        
        
        //sending Imageview containing tray image
        let trayImage = UIImage(systemName: "tray")
        dvc.incomingImageView = UIImageView(image: trayImage)
        dvc.incomingImageView?.tintColor = .systemRed
    }
    
    
    // MARK: - Data Fetching
    
    /// Fetches open issues from the Github API and reloads the table view
    func getOpenIssues() -> Void {
        GitHubClient.fetchOpenIssues { (issues, error) in
            
            // Ensure we have good data before anything else
            guard let issues = issues, error == nil else {
                print(error!)
                return
            }
            
            self.openIssuesList = issues
            self.tableView.reloadData()
            
        }
    }
    
    // MARK: - Refresh Control
    
    
    ///Refreshes the open issues list when the refresh control is triggered.
    @objc private func refreshIssues(sender: UIRefreshControl) -> Void {
        self.getOpenIssues()
        sender.endRefreshing()
    }
    
}
