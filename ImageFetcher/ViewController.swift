//
//  ViewController.swift
//  ImageFetcher
//
//  Created by Lukas Mohs on 11.09.17.
//  Copyright © 2017 Lukas Mohs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var searchButton: UIButton!
    
    @IBOutlet var inputTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.text = "Keyword";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        //self.showWaitingOverlay()
        var searchFlickrURL = ""
        if let keyWord = inputTextField.text {
             searchFlickrURL = "https://www.flickr.com/search/?text=" + keyWord.trimmingCharacters(in: .whitespacesAndNewlines) + "&license=2%2C3%2C4%2C5%2C6%2C9"
        } else {
            return
        }
        
        let url = NSURL(string: searchFlickrURL)
        
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if data != nil {
                    if error == nil {
                        if let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as String? {
                            //print(urlContent)
                            let matched = self.matches(for:"(?<=\\/\\/c1.staticflickr.com)[^'\\)]+", in: urlContent)
                            print(matched[0].count);
                            if matched[0].count < 40{
                                let imageURL = "http://c1.staticflickr.com" + matched[0]
                                print(imageURL)
                                self.getAndShowImage(url: imageURL);
                            } else{
                                self.showErrorMessage(text: "No image found")
                                print("No image found")
                            }
                        } else{
                            self.showErrorMessage(text: "Broken page content")
                            print("Broken page content")
                        }
                    }
                }else{
                    self.showErrorMessage(text: "Data fetching issue")
                    print("Data fetching issue")
                }
            })
            task.resume()
        } else{
            self.showErrorMessage(text: "Invalid Keyword")
            print("Invalid Keyword")
        }
    }
    
    // from: https://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios
    
    func showWaitingOverlay(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    
    // from: https://stackoverflow.com/questions/27880650/swift-extract-regex-matches
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func getAndShowImage(url:String){
        let catPictureURL = URL(string: url)!

        // from: https://stackoverflow.com/questions/39813497/swift-3-display-image-from-url
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.

            if let e = error {
                print("Error downloading picture: \(e)")
                self.showErrorMessage(text: "Error downloading picture")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded  picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and update on main thread
                        let picture = UIImage(data: imageData)
                        
                        DispatchQueue.main.async {
                            self.setImage(image: picture!);
                        }
                    } else {
                        self.showErrorMessage(text: "Couldn't get image: Image is nil")
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    self.showErrorMessage(text: "Couldn't get response code for some reason")
                    print("Couldn't get response code for some reason")
                }
            }
                    }
        
        downloadPicTask.resume()
    }
    
    func setImage(image :UIImage) {
        self.imageView.image = image
    }
    
    func showErrorMessage(text: String){
        let alert = UIAlertController(title: "Alert", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

