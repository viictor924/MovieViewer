//
//  movieDetailsViewController.swift
//  MovieViewer
//
//  Created by victor rodriguez on 4/1/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class movieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    
    var posterURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.posterImageView.setImageWith(posterURL as! URL)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
