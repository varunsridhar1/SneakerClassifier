//
//  PhotoViewController.swift
//  NSIx1.0
//
//  Created by Abhilash Chilakamarthi on 10/4/19.
//  Copyright © 2019 NSI. All rights reserved.
//

import UIKit


//Class to handle the image view screen that pops up after taking photo
class PhotoViewController: UIViewController {
    
    //will get set by our main ViewController
    //in capture output method
    var takenPhoto:UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //another if let that refers to image view UI object
        //and presents our photo
        //we could possibly add trained model here as well
        //because it might be nice to present the picture
        //along with its classification
        if let availableImage = takenPhoto{
            imageView.image = availableImage
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
