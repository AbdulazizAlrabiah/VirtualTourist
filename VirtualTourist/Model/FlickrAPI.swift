//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by aziz on 18/06/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

class FlickrAPI {
    
   static let flickrBaseURL: String = " https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=a996bd52a219a6eadaab624e2abd78b7&lat=&lon=&radius=7&per_page=&page=&format=json&nojsoncallback=1"
    
    class func request<T: Codable>(url: String, completion: @escaping (T) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        
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
                print(String(data: data, encoding: .utf8)!)
                let object = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(object)
                }
            } catch {
                print("connection error")
            }
        }.resume()
    }
    
    class func getImages() {

    }
}
