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
    
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var overviewScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var posterURL: NSURL?
    var smallPosterURL: NSURL?
    var largePosterURL: NSURL?
    
    var movieOverview: String?
    var movieTitle: String?
    var releaseDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setPosterImage()
       // self.posterImageView.setImageWith(posterURL as! URL)
        
        let contentWidth = overviewScrollView.frame.size.width
        let contentHeight = posterView.frame.origin.y+posterView.frame.size.height
        //let contentHeight = overviewScrollView.bounds.height*1.25
        overviewScrollView.contentSize =  CGSize(width: contentWidth, height:contentHeight)
        overviewLabel.text = movieOverview
        overviewLabel.sizeToFit()
        
        titleLabel.text = movieTitle
        releaseDateLabel.text = releaseDate
    }
        
        
        //====================================================================
    func setPosterImage(){
        let smallImageRequest = NSURLRequest(url: smallPosterURL as! URL) as? URLRequest
        let largeImageRequest = NSURLRequest(url: largePosterURL as! URL) as? URLRequest
        
        self.posterImageView.setImageWith(smallImageRequest!, placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    self.posterImageView.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    self.posterImageView.setImageWith(
                        largeImageRequest!,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.posterImageView.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
    }
        //====================================================================

        
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
