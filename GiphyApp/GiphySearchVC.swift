//
//  GiphySearchVC.swift
//  GiphyApp
//
//  Created by Connor - Udemy on 2017-06-20.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import UIKit
import CoreData

class GiphySearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIView!
    
    var controller: NSFetchedResultsController<SavedGiphy>!
    
    var searchKeyWords = String()
    
    var isTrending = true
    
    var giphy = Giphy()
    
    var duplicateDoNotAdd = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialHeartSetup()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        loadingIndicatorCall(load: true)
        
        giphy.downloadTrendingGiphs {
            // this will be called after network call is complete
            
            self.updateUI()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      // necessary to reload hearts as filled or unfilled when favourites have been immediately removed from GiphyFavouritesVC after being favourited in GiphySearchVC
        
        loadingIndicatorCall(load: true)
        
        updateUI()
        
    }
    
    
    // could probably find a way to make this safer. For now, this is fine
    func initialHeartSetup() {
        for _ in 0..<25 {
            GlobalVariables.heartArray.append(false)
        }
    }
    
    
    func loadingIndicatorCall(load: Bool) {
        
        if load {
            loadingView.isHidden = false
            loadingIndicator.isHidden = false
        } else {
            loadingView.isHidden = true
            loadingIndicator.isHidden = true
        }

    }
    
    
    func updateUI() {
        
        tableView.reloadData()
        
        loadingIndicatorCall(load: false)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return giphy.gifURLArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GiphySearchCell") as? GiphySearchCell {
        
                let id = giphy.idArray[indexPath.row]
             
                let gifURL = giphy.gifURLArray[indexPath.row]
            
                cell.configureCell(id: id, gifURL: gifURL, index: indexPath.row)
                
                return cell
            } else {
                return UITableViewCell()
            }

    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let hasText = searchBar.text {
           searchKeyWords = hasText.replacingOccurrences(of: " ", with: "+")
        }
        
        searchBar.resignFirstResponder()
        
        if searchKeyWords.isEmpty == false {
            
            loadingIndicatorCall(load: true)
            
            giphy.removeAll()
            
            GlobalVariables.heartArray.removeAll()
            
            initialHeartSetup()
            
            updateUI()
            
            loadingIndicatorCall(load: true)
            
            giphy.downloadSearchGiphs(searchTerms: searchKeyWords) {
                
                self.updateUI()
            }
        }
       
    }
    
   
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if let hasText = searchBar.text {
            searchKeyWords = hasText.replacingOccurrences(of: " ", with: "+")
        }
        
        searchBar.resignFirstResponder()
        
    }
    
    
    @IBAction func reloadTrendingGifs(_ sender: UIButton) {
        searchBar.text = nil
        loadingIndicatorCall(load: true)
        GlobalVariables.heartArray.removeAll()
        initialHeartSetup()
        giphy.downloadTrendingGiphs {
            self.updateUI()
        }
        
    }
    
    
    @IBAction func giphyHeartBtnTapped(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "EmptyHeart") {
            
            saveGiphyFetchRequest(index: sender.tag, url: GlobalVariables.urlArray[sender.tag])
            
            if duplicateDoNotAdd {
                duplicateWarning()
                duplicateDoNotAdd = false
            } else {
                
                sender.setImage(UIImage(named: "FilledHeart"), for: .normal)
                GlobalVariables.heartArray[sender.tag] = true
            }
            
        } else if sender.currentImage == UIImage(named: "FilledHeart") {
            
            sender.setImage(UIImage(named: "EmptyHeart"), for: .normal)
            GlobalVariables.heartArray[sender.tag] = false
            
            
            attemptFetchDeleteGiphy(url: GlobalVariables.urlArray[sender.tag])
        }
    }
    
    
    // Save Gif to core data. Checks to see if Gif is there or not already
    func saveGiphyFetchRequest(index: Int, url: String) {
        
        let fetchRequest: NSFetchRequest<SavedGiphy> = SavedGiphy.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            
            let error = error as NSError
            print("\(error)")
        }
        
        var duplicate: Bool = false
        
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                if object.url == url {
                    duplicate = true
                }
                
            }
        }
        
        if duplicate == false {
            let giphy = SavedGiphy(context: context)
            giphy.url = GlobalVariables.urlArray[index]
            giphy.id = GlobalVariables.idArray[index]
            
            ad.saveContext()
        } else {
           
            duplicateDoNotAdd = true
        }

        
        
        
    }
    
    // Deletes Gif from core data
    func attemptFetchDeleteGiphy(url: String) {
        
        let fetchRequest: NSFetchRequest<SavedGiphy> = SavedGiphy.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            
            let error = error as NSError
            print("\(error)")
        }
        
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                if object.url == url {
                     context.delete(object)
                }
               
            }
            ad.saveContext()
        }
        
        
    }
    
    // Warning Pop up for attempt to favourite a gif that has already been favourited
    func duplicateWarning () {
        
        let alert = UIAlertController(title: "Duplicate Gif", message: "You already favourited this Gif! See your favourites!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
