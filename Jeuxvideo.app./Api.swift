//
//  Api.swift
//  Jeuvdeo.app
//
//  Created by William Clement on 31/10/2021.
//

import SwiftUI

struct Rendered:Codable{
    var rendered: String
}

struct Post: Codable, Identifiable {
    var id: Int
    var date: String
    var date_gmt: String
    var modified: String
    var modified_gmt: String
    var slug: String
    var status: String
    var type: String
    var link: String
    var content: Rendered
    var guid: Rendered
    var title: Rendered
}

class Api{

    func getPosts(completition: @escaping([Post]) -> (), page: Int){
        guard let url = URL(string: "https://www.jeuxvideo.app/wp-json/wp/v2/posts?page="+String(page)) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let posts = try! JSONDecoder().decode([Post].self, from: data!)
            
            DispatchQueue.main.async {
                completition(posts)
                //print(posts.count)
            }
           
        }
        .resume()
    }
}
