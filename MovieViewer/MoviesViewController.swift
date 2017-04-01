//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by victor rodriguez on 3/31/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies:[NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        requestMovie()

        // Do any additional setup after loading the view.
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
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        
        let movie = movies?[indexPath.row]
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
        let imageURL = getPosterURL(index: indexPath.row)
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWith(imageURL as URL)//get image from URL
        
        
        print("cell.textLabel.text == \(cell.textLabel?.text)")
        return cell
    }

    
    func requestMovie(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        print("apiKey == \(apiKey)")
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            print("response == \(responseDictionary)")
                        self.movies = responseDictionary.object(forKey: "results") as? [NSDictionary]
                        self.tableView.reloadData() 
                }
            }
        });
        task.resume()
    }
    
    
    func getPosterURL(index: Int) ->NSURL{
        let movie = movies?[index]
        let baseURL = "https://image.tmdb.org/t/p/"
        let size = "w342" //High resolution: "original", medium resolution: "w342", low resolution: "w45"
        let filePath = movie?["poster_path"] as! String
        let imageURL = NSURL(string: baseURL+size+filePath)
        return imageURL!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let vc = segue.destination as! movieDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = self.tableView.indexPathForSelectedRow

        // Pass the selected object to the new view controller.
        
        
        vc.posterURL = getPosterURL(index: (indexPath?.row)!)
    }
    

}
