//
//  JVViewController.swift
//  Jeuxvideo.app
//
//  Created by William Clement on 31/10/2021.
//
import SwiftUI
import UIKit


class JVViewController: UIViewController {
    @IBOutlet var TableView: UITableView!
    var titre = [String]()
    
    var contenu = [String]()
    
    var p: [Post]
    
    var hasDataToLoad: Bool = true
    
    var incr: Int = 1
    
    required init?(coder aDecoder: NSCoder) {
        let r: Rendered = Rendered(rendered: "")
        p = [Post(id: 0, date: "", date_gmt: "", modified: "", modified_gmt: "", slug: "", status: "", type: "", link: "", content: r, guid: r, title: r)]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Jeuxvideo.app"
        TableView.delegate = self
        TableView.dataSource = self
        Api().getPosts (completition:{ _p in
            //print(_p)
            //print("____",_post[0].title.rendered)
            for i in 0..._p.count-1 {
                self.titre.append(String.decodingHTMLEntities(_p[i].title.rendered)())
                self.contenu.append(String.decodingHTMLEntities(_p[i].content.rendered)())
            }
            
            self.TableView.reloadData()
        } , page: 1)
        incr = incr + 1
    }
}


extension JVViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TableView.deselectRow(at: indexPath, animated: true)
        
        let articleview = storyboard?.instantiateViewController(identifier: "article") as! ArticleViewController
        articleview.title  = titre[indexPath.row]
    
//        let xml = try? SwiftSoup.parse(contenu[indexPath.row])
//
//        let contenu_article = xml?.body()?.children().compactMap {
//            try? PostContent(element: $0)
//        }
        
        articleview.content = contenu[indexPath.row]
        
        navigationController?.pushViewController(articleview, animated: true)
    }
}

extension JVViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = titre[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //delete
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("Reload more data")
        if hasDataToLoad == true{
            LoadMoreData(indexPath: indexPath)
        }
    }
    
    func LoadMoreData(indexPath: IndexPath) {
        let lastItem = titre.count
        //print("last: " + String(lastItem))
        //print("lpath: " + String(indexPath.row))
        if lastItem == indexPath.row + 1{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                Api().getPosts (completition:{ _p in
                    if(_p.count == 5){
                        self.incr = self.incr + 1
                    }
                    if(self.hasDataToLoad){
                        _p.forEach { g in
                            self.titre.append(String.decodingHTMLEntities(g.title.rendered)())
                            self.contenu.append(String.decodingHTMLEntities(g.content.rendered)())
                        }
                    }
                    if(_p.count < 5){
                        self.hasDataToLoad = false
                    }
                    self.TableView.reloadData()
                } , page: self.incr)
            }
            
//            Api().getPosts (completition:{ _p in
//                if(_p.count == 5){
//                    self.incr = self.incr + 1
//                }
//                self.TableView.reloadData()
//            } , page: incr)
        }
    }
    
}


