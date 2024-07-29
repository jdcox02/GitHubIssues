//
//  IssueDetailViewController.swift
//  Project3
//
//  Created by Joshua Cox on 1/22/24.
//

import UIKit

class IssueDetailViewController: UIViewController {
    
    // MARK: Outlets
    
    /// Label to display the issue's title
    @IBOutlet weak var issueTitleLabel: UILabel!
    
    //Label to display the issue's author
    @IBOutlet weak var authorLabel: UILabel!
    
    /// Label to display the date the issue was submitted
    @IBOutlet weak var dateLabel: UILabel!
    
    /// Label to display a description of the sisue
    @IBOutlet weak var issueDescriptionText: UITextView!
    
    /// Image view to display an image related to the status of the issue
    @IBOutlet weak var issueImageView: UIImageView!
    
    
    // MARK: - Properties
    
    /// These are variables that will be passed via the segue
    var incomingIssueTitle: String = ""
    var incomingAuthor: String = ""
    var incomingBody: String = ""
    var incomingDate: String = ""
    var incomingImageView: UIImageView?

    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        // Update UI element values received via segue
        issueTitleLabel?.text = incomingIssueTitle
        authorLabel?.text = incomingAuthor
        issueDescriptionText?.text = incomingBody
        
        //Convert and format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        //Convert the date string to a Date object
        if let formattedDate = dateFormatter.date(from: incomingDate) {
            print(formattedDate)
            let displayDateFormatter = DateFormatter()
            displayDateFormatter.dateStyle = .long
            displayDateFormatter.timeStyle = .none
            
            // Convert the Date Object to a user-friendly string
            let formattedDateAsString = "\(displayDateFormatter.string(from: formattedDate))"
            print(formattedDateAsString)
            
            //Set the formatted date string to the date label
            dateLabel.text = formattedDateAsString
        } else {
            dateLabel?.text = "Unable to format date."
        }
        
        //Update the image view with the image and tint color
        issueImageView.image = incomingImageView?.image
        issueImageView.tintColor = incomingImageView?.tintColor
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
