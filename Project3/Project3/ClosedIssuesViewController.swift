//
//  ClosedIssuesViewController.swift
//
//  Created by Joshua Cox on 1/21/24.
//

import UIKit


/// ViewController responsible for displaying a list of closed GitHub issues.
class ClosedIssuesViewController: UITableViewController {
    
    // MARK: - Properties
    
    /// Array to hold the list of closed issues fetched from Github.
    var closedIssuesList: [GitHubIssue] = []

    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch closed issues when the view is about to appear.
        self.getClosedIssues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Checking version and setting up pull to refresh accordingly
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
        // Return the number of sections in the table view
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section (number of closed issues).
        return closedIssuesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell and configure it with issue data
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClosedIssueCell", for: indexPath) as! IssueTableViewCell
        if let title = closedIssuesList[indexPath.row].title {
            cell.issueLabel?.text = "\(title)"
        } else {
            cell.issueLabel?.text = ""
        }
        if let username = closedIssuesList[indexPath.row].user{
            cell.username?.text = "@\(username.login)"
        } else {cell.username?.text = ""}


        // Additional cell configuration can be done here.

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the height for each row in the table view.
        return 80
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Prepare for segue to IssueDetailViewController
        guard let selectedPath = tableView.indexPathForSelectedRow else {
            print("Invalid index path")
            return
        }
       
        // Get the destination view controller and configure it with selected issue details.
        let dvc = segue.destination as! IssueDetailViewController
        
        //sending issue title text
        if let title = closedIssuesList[selectedPath.row].title {
            dvc.incomingIssueTitle = "\(title)"
        } else {
            dvc.incomingIssueTitle = ""
        }
        
        //sending author text
        let author = "\(closedIssuesList[selectedPath.row].user!.login)"
        dvc.incomingAuthor = "@\(author)"

        //sending issue body text
        if let body = closedIssuesList[selectedPath.row].body {
            dvc.incomingBody = "\(body)"
        } else {
            dvc.incomingBody = ""
        }
        
        
        //sending date text
        let date = closedIssuesList[selectedPath.row].createdAt
        dvc.incomingDate = "\(date)"

        
        //sending Imageview containing tray image
        let trayImage = UIImage(systemName: "checkmark.circle.fill")
        dvc.incomingImageView = UIImageView(image: trayImage)
        dvc.incomingImageView?.tintColor = .systemGreen
}
    
    // MARK: - Data Fetching
    
    
    /// Fetches closed issues from the Github API and reloads the table view.
    func getClosedIssues() -> Void {
        
        GitHubClient.fetchClosedIssues { (issues, error) in
            
            // Ensure we have good data before anything else
            guard let issues = issues, error == nil else {
                print(error!)
                return
            }
            
            self.closedIssuesList = issues
            self.tableView.reloadData()
            
        }
        
    }
    
    
    // MARK: - Refresh Control
    
    /// Refreshes the closed issues list when the refresh control is triggered.
    @objc private func refreshIssues(sender: UIRefreshControl) -> Void {
        self.getClosedIssues()
        sender.endRefreshing()
    }
    
}


