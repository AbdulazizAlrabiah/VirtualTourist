//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by aziz on 18/06/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import CoreData
import UIKit

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [Photo]?
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var pin: Pin!
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noImagesLabel.isHidden = true
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            
        }
        
//        if let result = try? dataController.viewContext.fetch(fetchRequest) {
//            if result.isEmpty {
//                print("empty")
//                requestImages()
//            } else {
//                images = result
//                collectionView.reloadData()
//            }
//        }
    }
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        
        requestImages()
    }
    
    func requestImages() {
        
        FlickrAPI.getImages(lat: pin.latitude, long: pin.longtitude, completion: { (images) in
            
            self.fillPhotosAndSave(images: images)
            
            if self.images?.count == 0 {
                self.noImagesLabel.isHidden = false
            }
            
            print("images = ", images.count)
            self.collectionView.reloadData()
        }) { (number) in
            //            self.num = number
            //            print("a")
            //            self.collectionView.reloadData()
        }
    }
    
    func fillPhotosAndSave(images: [Data]) {
        
        self.images = []
        
        for image in images {
            
            let photo = Photo(context: dataController.viewContext)
            photo.image = image
            photo.pin = self.pin
            try? self.dataController.viewContext.save()
            self.images?.append(photo)
        }
        print("done")
    }
}
extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images?.count ?? 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photos", for: indexPath) as! CollectionViewCell
        
        guard images != nil else {
            cell.activityIndicator.startAnimating()
            return cell
        }
        print("here")
        let image = UIImage(data: (images?[indexPath.row].image)!)
        
        cell.imageView.image = image
        cell.activityIndicator.stopAnimating()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    
}
