//
//  ViewController.swift
//  AI Album Info
//
//  Created by Max Pothier on 7/13/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var albumInput: UITextField!
    @IBOutlet weak var appTitle: UILabel!
        
    let apiManager = ApiManager()
    
    var albumTitle: String?
    var albumDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumInput.delegate = self
        appTitle.adjustsFontSizeToFitWidth = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.aboutTitleValue = "About \(albumTitle ?? "the Album")"
            destinationVC.descriptionValue = albumDescription
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        albumInput.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let album = albumInput.text {
            self.albumTitle = album
            apiManager.generateIGCaption(title: album) { caption in
                DispatchQueue.main.async {
                    if let caption = caption {
                        self.albumDescription = caption
                        self.performSegue(withIdentifier: "goToResult", sender: self)
                    } else {
                        print("Error generating caption")
                    }
                }
            }
        }
        
        albumInput.text = ""
    }
}
