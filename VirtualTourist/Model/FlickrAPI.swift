//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by aziz on 18/06/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit

class FlickrAPI {
    
    static var arrayOfURLS: [String] = []
    static var arrayOfData: [Data] = []
    
    struct Endpoint {
        static let flickrBaseURL: String = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=a996bd52a219a6eadaab624e2abd78b7"
        
        static func fillURL(random: Int, lat: Double, long: Double) -> String {
            return flickrBaseURL +  "&lat=\(lat)&lon=\(long)&radius=20&per_page=15&page=\(random)&format=json&nojsoncallback=1"
        }
    }
    
    class func request<T: Codable>(url: String, completion: @escaping (T) -> Void) {
        
        let request = URLRequest(url: URL(string: url)!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    print("connection error")
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    print("connection error")
                }
                return
            }
            do {
                //print(String(data: data, encoding: .utf8)!)
                let object = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(object)
                }
            } catch {
                print("connection error")
            }
            }.resume()
    }
    
    class func getImages(lat: Double, long: Double, completion: @escaping ([Data]) -> Void, number: @escaping (Int) -> Void) {
        
        let random = Int.random(in: 1...10)
        print(random)
        request(url: Endpoint.fillURL(random: random, lat: lat, long: long)) { (results: PhotoAlbumResponse) in
            
           // number(results.photos.photo.count)
            
            getData(photos: results.photos.photo)
            
            completion(self.arrayOfData)
        }
        arrayOfURLS.removeAll()
        arrayOfData.removeAll()
    }
    
//    class func totalPhotos(lat: Double, long: Double, completion: @escaping (Int) -> Void) {
//
//        let random = Int.random(in: 1...100)
//
//        request(url: Endpoint.fillURL(random: random, lat: lat, long: long)) { (results: PhotoAlbumResponse) in
//            completion( results.photos.photo.count)
//        }
//    }
    
    class func getData(photos: [PhotoAlbumArrayResponse]) {
        
        for (index, photo) in photos.enumerated() {
            arrayOfURLS.append("https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_s.jpg")
            
            let imageData = try? Data(contentsOf: URL(string: arrayOfURLS[index])!)
            
            arrayOfData.append(imageData!)
        }
    }
    
//    class func getImageData(url: String) -> Data {
//
//
//
//
//
//        return imageData!
//
//        //let image = UIImage(data: imagData!)
//    }
}
