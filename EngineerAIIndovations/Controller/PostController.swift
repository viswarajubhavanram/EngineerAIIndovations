//
//  PostController.swift
//  EngineerAIIndovations
//
//  Created by bhavan on 19/12/19.
//  Copyright © 2019 Indovations. All rights reserved.
//

import UIKit

class PostController: UIViewController {
    
    // MARK: - Cell Identifier
    let postsCell = "PostsCell"
    
    // MARK: - Refreshing Object
    let refreshControl = UIRefreshControl()
    
    // MARK: - Respones Object
    var postResponseResult = [PostResponseResult]()
    
    // MARK: - switchSelectionArray Object
    var forToggelSwitch = [PostResponseResult]()

    // MARK: - ActivityIndicator Object
    let activityIndicator = ActivityIndicator()

    var page = 1

    // MARK: - TableView Object
    lazy var postsTV:UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.allowsSelection = true
        table.backgroundColor = .clear
        table.isScrollEnabled = true
        table.delegate = self
        table.dataSource = self
        refreshControl.addTarget(self, action: #selector(postsRefreshAction), for: .valueChanged)
        table.refreshControl = refreshControl
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Selected 0"
        
        view.backgroundColor = .white
        
        view.addSubview(postsTV)
                
        constraintsForUIUsingAnchors()

    }
    
    //MARK: - For Adding Constraints

    func constraintsForUIUsingAnchors(){
        
        postsTV.setAnchor(top: view.safeTopAnchor, left: view.safeLeftAnchor , bottom: view.safeBottomAnchor  , right: view.safeRightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        registerCells()
        
        requestPosts(page: page)
        
    }
    
    
    
    // MARK: - Registering Table View Cell
    fileprivate func registerCells() {
        
        postsTV.estimatedRowHeight = 75
        postsTV.rowHeight = UITableView.automaticDimension
        postsTV.register(PostsCell.self, forCellReuseIdentifier: postsCell)
        
    }
    
    // MARK: - Api Calling Result
    func finishPost (message:String, data:Data? , tag: String) -> Void
    {
        do
        {
            if let jsonData = data
            {
                
                UtilityCode.hideActivityIndicator(target: self, activity: activityIndicator)
                
                if tag == "getPosts" {
                    
                    refreshControl.endRefreshing()
                    
                    let parsedData = try JSONDecoder().decode(PostsResponse.self, from: jsonData)
                    
                    if parsedData.hits.count > 0{
                        
                        if page == 1 {
                            
                            postResponseResult.removeAll()
                            
                        }
                        
                        postResponseResult.append(contentsOf:parsedData.hits)
                        postsTV.reloadData()
                    
                    }
                }
            }
            
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    // MARK: - Page Refreshing
    @objc func postsRefreshAction(){
        
        self.title = "Selected \(String(forToggelSwitch.count))"
        page = 1
        requestPosts(page: page)

    }
    
    // MARK: - Pagenation
    func requestPosts(page: Int){
        
       // print(page)
        
        let url = Config.base_url+String(page)
        NetworkManager.callApi(url:url, params:"" ,methodType:"GET",tag: "getPosts" ,completion: finishPost)
        
        UtilityCode.showActivityIndicator (target: self, title: "Loding..." ,activity : activityIndicator)

    }

}

// MARK: - Table View Datasource & Delegate Methods
extension PostController : UITableViewDelegate,UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postResponseResult.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postsTV.dequeueReusableCell(withIdentifier: postsCell, for: indexPath) as! PostsCell
        
        let index = postResponseResult[indexPath.row]

        cell.postResponseResult = index
        
        cell.toggle.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        
        
        if forToggelSwitch.contains(where: { $0.objectID == index.objectID }) {
                   
                
            cell.toggle.setOn(true, animated: true)
                
        }else {
                   
        
            cell.toggle.setOn(false, animated: true)

        }
        
        if indexPath.row == postResponseResult.count-1 {
            
            page = page+1
            
            requestPosts(page : page)
            
        }
    
        return cell
        
    }
    
    
    // MARK: - TableViewSelection Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let index = postResponseResult[indexPath.row]

        if let index = forToggelSwitch.firstIndex(where: { $0.objectID == index.objectID }) {

            self.forToggelSwitch.remove(at: index)

        }else{
            
            
            self.forToggelSwitch.append(index)
            
        }
        
        postsTV.reloadData()
        
        self.title = "Selected \(String(forToggelSwitch.count))"

    }
     
    // MARK: - SwitchAction
    @objc func toggleSwitch(sender: UISwitch) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.postsTV)
              
        let indexPath = self.postsTV.indexPathForRow(at: buttonPosition)
               
              
        let index = postResponseResult[(indexPath?.row)!]
        
        
        if let index = forToggelSwitch.firstIndex(where: { $0.objectID == index.objectID }) {

            self.forToggelSwitch.remove(at: index)

        }else{
                   
            self.forToggelSwitch.append(index)

        }
               
        postsTV.reloadData()
        
        self.title = "Selected \(String(forToggelSwitch.count))"

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



