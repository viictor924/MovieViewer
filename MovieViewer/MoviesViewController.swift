//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by victor rodriguez on 3/31/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var movies:[NSDictionary]?
    var refreshControl: UIRefreshControl?
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refresh), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        //download movies from movie database API
        requestMovie()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated:false)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies?[indexPath.row]
        let title = movie?["title"] as! String
        let overview = getMovieDetail(index: indexPath.row, detail: "overview")
        let imageURL = getPosterURL(index: indexPath.row)
        
        cell.titleLabel.text = title
        cell.titleLabel.sizeToFit()
        cell.overviewLabel.text = overview
        cell.overviewLabel.sizeToFit()
        
        cell.posterView.setImageWith(imageURL as URL)//get image from URL
        return cell
    }

    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refresh(sender:AnyObject)
    {
        requestMovie()
        print("end refreshing")
        self.refreshControl?.endRefreshing()
    }
    
    func requestMovie(){
        // Display HUD right before the request is made
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Loading movies"
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        print("endpoint == \(endpoint)")
        
        let URLString = "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)"
        print("URLString == \(URLString)")
        
        let url = NSURL(string: URLString)!
        print("url == \(url)")
        
        let request = NSURLRequest(url: url as URL)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
        
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.networkErrorView.isHidden = true
                        
                        self.movies = responseDictionary.object(forKey: "results") as? [NSDictionary]
                        self.tableView.reloadData()
                        spinningActivity.hide(animated: true)
                       
                }
                } else{
                    self.networkErrorView.isHidden = false
                    if let e = error{
                        print("Error: \(e)")
                    }
            }

            });
        task.resume()
    }
    
    
    func getPosterURL(index: Int) ->NSURL{
        let movie = movies?[index]
        let baseURL = "https://image.tmdb.org/t/p/"
        let size = "original" //High resolution: "original", medium resolution: "w342", low resolution: "w45"
        
        let filePath = movie?["poster_path"] as! String
        let imageURL = NSURL(string: baseURL+size+filePath)
        return imageURL!
    }
    
    func getMovieDetail(index: Int, detail: String) -> String{
        let movie = movies?[index]
        let extractedDetail = movie?[detail] as! String
        return extractedDetail
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let vc = segue.destination as! movieDetailsViewController
        
        let indexPath = self.tableView.indexPathForSelectedRow
        let selectedMovieIndex = indexPath?.row
        
        // Pass the selected object to the new view controller.
        vc.movieOverview = getMovieDetail(index: selectedMovieIndex!, detail: "overview")
        vc.movieTitle = getMovieDetail(index: selectedMovieIndex!, detail: "original_title")
        vc.releaseDate = getMovieDetail(index: selectedMovieIndex!, detail: "release_date")
        vc.posterURL = getPosterURL(index: selectedMovieIndex!)
    }
    

}
