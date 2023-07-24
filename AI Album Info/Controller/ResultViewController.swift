//
//  ResultViewController.swift
//  AI Album Info
//
//  Created by Max Pothier on 7/24/23.
//

import UIKit

class ResultViewController: UIViewController {
    
    var aboutTitleValue: String?
    var descriptionValue: String?
    
    @IBOutlet weak var aboutTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutTitleLabel.text = aboutTitleValue
        descriptionLabel.text = descriptionValue
    }
    
    @IBAction func exploreAnotherPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
