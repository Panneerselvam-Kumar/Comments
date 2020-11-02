//
//  ViewController.swift
//  Comments
//
//  Created by QOL on 29/10/20.
//  Copyright © 2020 QOL. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class ViewController: UIViewController
{
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    var commentsAndReply = [String : Any]()
    var selectedIndex = -1
    
    
    override func viewDidLoad()
    {
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        commentsTableView.backgroundColor = UIColor.white
        commentsTableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        guard let path = Bundle.main.path(forResource: "Comments", ofType: "json") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            
            let data = try Data(contentsOf: url)
            
            let json = try JSON(data: data)
            
            let dict = json["Comments"]
            
            for i in 0..<dict.count
            {
                let comments = dict["\(i + 1)"]["comment"].string
                
                let replies = dict["\(i + 1)"]["reply"].arrayObject
                
                commentsAndReply[comments!] = replies
            }
        } catch {
            
            print("ERROR", error)
        }
        
        commentsTableView.reloadData()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return commentsAndReply.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if selectedIndex == section
        {
            let name1 = Array(commentsAndReply)[section].key
            print("NAME", name1)
            
            //            tableView.section.titleLabel?.text = name1
            let name = Array(commentsAndReply)[section].value as? NSArray
            return name!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height)
        
        let name = Array(commentsAndReply)[indexPath.section].value as? NSArray
        
        let nameString = name![indexPath.row] as? String
        
        let nameArray = nameString?.components(separatedBy: ":")
        
        let att1 = [NSAttributedString.Key.font : UIFont(name: "Avenir Heavy", size: 12), NSAttributedString.Key.foregroundColor : UIColor.red]
        
        let att2 = [NSAttributedString.Key.font : UIFont(name: "Avenir Heavy", size: 12), NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let attributedString1 = NSMutableAttributedString(string:nameArray![0], attributes:att1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:nameArray![1], attributes:att2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        
        if selectedIndex == indexPath.section
        {
            if indexPath.row == 0
            {
                cell.textLabel?.attributedText = attributedString1
            }
            else
            {
                cell.textLabel?.attributedText = attributedString1
            }
        }
        else
        {
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.section
        {
            selectedIndex = -1
        }
        else
        {
            selectedIndex = indexPath.section
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        
        let name = Array(commentsAndReply)[section].key
        print("NAME", name)
        
        let reply = Array(commentsAndReply)[section].value as! NSArray
        
        let tapButton = UIButton()
        tapButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        tapButton.backgroundColor = UIColor.white
        tapButton.setTitle("\(name)     (\(reply.count) Replies)", for: .normal)
        tapButton.setTitleColor(UIColor.black, for: .normal)
        tapButton.tag = section
        tapButton.contentHorizontalAlignment = .left
        tapButton.addTarget(self, action: #selector(self.buttonAction(sender:)), for: .touchUpInside)
        cell?.addSubview(tapButton)
        
        let arrowImageView = UIImageView()
        arrowImageView.frame = CGRect(x: (cell?.frame.width)! - 20, y: 10, width: 10, height: 10)
        cell?.addSubview(arrowImageView)
        
        if selectedIndex == section
        {
            tapButton.titleLabel?.font = UIFont(name: "Avenir Heavy", size: 15)
            cell?.backgroundColor = UIColor.lightGray
            arrowImageView.image = UIImage(named: "downArrow")
        }
        else
        {
            tapButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 15)
            cell?.backgroundColor = UIColor.clear
            arrowImageView.image = UIImage(named: "rightArrow")
        }
        
        return cell
    }
    
    @objc func buttonAction(sender : UIButton)
    {
        if selectedIndex == sender.tag
        {
            selectedIndex = -1
        }
        else
        {
            selectedIndex = sender.tag
        }
        
        print("BUTTON SECTION", sender.tag)
        commentsTableView.reloadData()
        //        commentsTableView.beginUpdates()
        //        commentsTableView.endUpdates()
    }
    
}

