//
//  GiphyFavouritesVC.swift
//  GiphyApp
//
//  Created by Connor - Udemy on 2017-06-20.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import UIKit
import CoreData

class GiphyFavouritesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var controller: NSFetchedResultsController<SavedGiphy>!
    
    var iip = [IndexPath]()
    var dip = [IndexPath]()
    var ins: NSIndexSet?
    var des: NSIndexSet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        attemptFetch()
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiphyFavouriteCell", for: indexPath) as? GiphyFavouriteCell {
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func configureCell(cell: GiphyFavouriteCell, indexPath: NSIndexPath) {
        
        let savedGiphy = controller.object(at: indexPath as IndexPath)
        cell.configureCell(savedGiphy: savedGiphy)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if let sections = controller.sections {
            
            return sections.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //delete a favourite here
        
        let giphyToDelete = controller.object(at: indexPath as IndexPath)
        
        //remove heart from search table view if necessary
        if let urlToDelete = giphyToDelete.url {
            for url in GlobalVariables.urlArray {
                if url == urlToDelete {
                    if let index = GlobalVariables.urlArray.index(of: url) {
                        GlobalVariables.heartArray[index] = false
                    }
                }
            }
        }
        // continue with core data deletion
        context.delete(giphyToDelete)
        ad.saveContext()
        
        
    }
    
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<SavedGiphy> = SavedGiphy.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
       
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            
            let error = error as NSError
            print("\(error)")
        }
        
    }
  
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if controller == self.controller {
            
            switch(type) {
                
                
            case.insert:
                if let indexPath = newIndexPath {
                iip.append(indexPath)
                }
                break
            case.delete:
                if let indexPath = indexPath {
                    dip.append(indexPath)
                }
                break
            case.update:
                if let indexPath = indexPath {
                    let cell = collectionView.cellForItem(at: indexPath) as! GiphyFavouriteCell
                    configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                self.collectionView!.reloadItems(at: [indexPath])
                }
                break
            default:
                break
            }

        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch(type) {
        case.insert:
            
            ins = NSIndexSet(index: sectionIndex)
            break
        case.delete:
            
            des = NSIndexSet(index: sectionIndex)
            break
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.collectionView!.performBatchUpdates({
            
            self.collectionView!.insertItems(at: self.iip)
            self.collectionView!.deleteItems(at: self.dip)
            if self.ins != nil {
                self.collectionView!.insertSections(self.ins! as IndexSet)
            }
            if self.des != nil {
                self.collectionView!.deleteSections(self.des! as IndexSet)
            }
            
        }, completion: {completed in
            
            self.iip.removeAll(keepingCapacity: false)
            self.dip.removeAll(keepingCapacity: false)
            self.ins = nil
            self.des = nil
        })
        
    }
    

    


    

}
