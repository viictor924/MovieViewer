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
    @IBOutlet weak var overviewScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var posterURL: NSURL?
    var movieOverview: String?
    var movieTitle: String?
    var releaseDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.posterImageView.setImageWith(posterURL as! URL)
        let contentWidth = overviewScrollView.bounds.width
        let contentHeight = overviewScrollView.bounds.height*1.25
        overviewScrollView.contentSize =  CGSize(width: contentWidth, height:contentHeight)
        overviewLabel.text = movieOverview
        overviewLabel.sizeToFit()
        
        titleLabel.text = movieTitle
        releaseDateLabel.text = releaseDate
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
