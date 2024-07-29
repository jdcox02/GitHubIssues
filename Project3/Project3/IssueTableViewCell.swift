//
//  IssueTableViewCell.swift
//  Project3
//
//  Created by Joshua Cox on 1/21/24.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    /// Label to display the title of the issue
    @IBOutlet weak var issueLabel: UILabel!
    
    /// Label to display the username of the issue author
    @IBOutlet weak var username: UILabel!
    
    /// Image view to display an optional image related to the issue status
    @IBOutlet weak var issueImage: UIImageView!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    
    // MARK: - Selection State
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
