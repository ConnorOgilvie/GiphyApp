//
//  Giphy.swift
//  GiphyApp
//
//  Created by Connor - Udemy on 2017-06-21.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import Foundation
import Alamofire

class Giphy {
    
    private var _idArray: [String] = []
    private var _trendingURL: String!
    private var _gifURLArray: [String] = []
    
    var idArray: [String] {
        return _idArray
    }
  
    
    var trendingUrl: String {
        return _trendingURL
    }
    
    var gifURLArray: [String] {
        return _gifURLArray
    }
    
    init() {
        
        self._trendingURL = URL_TRENDING
    }
    
    
    func removeAll() {
        _gifURLArray.removeAll()
        _idArray.removeAll()
        GlobalVariables.urlArray.removeAll()
        GlobalVariables.idArray.removeAll()
    }
    
    func downloadTrendingGiphs(completed: @escaping DownloadComplete) {
        
        self.removeAll()
        
        Alamofire.request(_trendingURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let gifArrayDict = dict["data"] as? [Dictionary<String, AnyObject>] {
                    
                    for gifData in gifArrayDict {
                       
                        if let id = gifData["id"] as? String {
                            
                           self._idArray.append("\(id)")
                            GlobalVariables.idArray.append("\(id)")
                        }
                        
                        
                        if let gifImgSet = gifData["images"] as? Dictionary<String, AnyObject> {
                            
                            if let gifImgSrc = gifImgSet["fixed_width_small"] as? Dictionary<String, AnyObject> {
                                
                                if let gifImgSrcUrl = gifImgSrc["url"] as? String {
                                    
                                    self._gifURLArray.append(gifImgSrcUrl)
                                    GlobalVariables.urlArray.append(gifImgSrcUrl)
                                }
                                
                                // for testing only
//                                if let imgSize = gifImgSrc["size"] as? String {
//                                    self._size.append(imgSize)
//                                }
                            }
                        }
                        
                    }
                   // print(self._idArray)
                  //  print(self._gifURLArray)
                    
                }
            }
            completed()
            
        }
        
    }
    
    
    func downloadSearchGiphs(searchTerms: String, completed: @escaping DownloadComplete) {
        
        self.removeAll()
        
        let searchURL = URL_BASE_SEARCH+searchTerms+API_KEY
        
        Alamofire.request(searchURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let gifArrayDict = dict["data"] as? [Dictionary<String, AnyObject>] {
                    
                    for gifData in gifArrayDict {
                        
                        if let id = gifData["id"] as? String {
                            
                            self._idArray.append("\(id)")
                            GlobalVariables.idArray.append("\(id)")
                        }
                        
                        
                        if let gifImgSet = gifData["images"] as? Dictionary<String, AnyObject> {
                            
                            if let gifImgSrc = gifImgSet["fixed_width_small"] as? Dictionary<String, AnyObject> {
                                
                                if let gifImgSrcUrl = gifImgSrc["url"] as? String {
                                    
                                    self._gifURLArray.append(gifImgSrcUrl)
                                    GlobalVariables.urlArray.append(gifImgSrcUrl)
                                }
                                
                            }
                        }
                        
                    }
                    
                }
            }
            completed()
        }
        
    }
    
    
}
