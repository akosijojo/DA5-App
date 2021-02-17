//
//  ContactViewController.swift
//  DA5-APP
//
//  Created by Jojo on 2/9/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit
import Contacts

struct ExpandableNames {
    var isExpanded: Bool
    var names: [FavoritableContact]
}

struct FavoritableContact {
    let contact: CNContact
    var hasFavorited: Bool
}

class ContactViewController: UITableViewController {

    let cellId = "cellId"
    
    func someMethodIWantToCall(cell: UITableViewCell) {
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        print(contact)
        
        let hasFavorited = contact.hasFavorited
        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
        
//        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
    }
    
    var twoDimensionalArray : [ExpandableNames] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private func fetchContacts() {
        print("Attempting to fetch contacts today..")
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access:", err)
                return
            }
            
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    
                    var favoritableContacts = [FavoritableContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                    })
                    
                    let names = ExpandableNames(isExpanded: true, names: favoritableContacts)
                    self.twoDimensionalArray = [names]
                    
                } catch let err {
                    print("Failed to enumerate contacts:", err)
                }
                
            } else {
                print("Access denied..")
            }
        }
    }
    
    var showIndexPaths = false
//
//    @objc func handleShowIndexPath() {
//
//        print("Attemping reload animation of indexPaths...")
//
//        // build all the indexPaths we want to reload
//        var indexPathsToReload = [IndexPath]()
//
//        for section in twoDimensionalArray.indices {
//            for row in twoDimensionalArray[section].names.indices {
//                print(section, row)
//                let indexPath = IndexPath(row: row, section: section)
//                indexPathsToReload.append(indexPath)
//            }
//        }
//
////        for index in twoDimensionalArray[0].indices {
////            let indexPath = IndexPath(row: index, section: 0)
////            indexPathsToReload.append(indexPath)
////        }
//
//        showIndexPaths = !showIndexPaths
//
//        let animationStyle = showIndexPaths ? UITableViewRowAnimation.right : .left
//
//        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContacts()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)

        button.tag = section

        return button
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in twoDimensionalArray[section].names.indices {
            print(0, row)
            let indexPath = IndexPath(item: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = twoDimensionalArray[section].isExpanded
        twoDimensionalArray[section].isExpanded = !isExpanded
        
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDimensionalArray[section].isExpanded {
            return 0
        }
        
        return twoDimensionalArray[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.link = self
        
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray
        
        if showIndexPaths {
//            cell.textLabel?.text = "\(favoritableContact.name)   Section:\(indexPath.section) Row:\(indexPath.row)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTING : \(twoDimensionalArray[indexPath.section].names[indexPath.row].contact.phoneNumbers.first?.value.stringValue)")
    }

}



class ContactCell: UITableViewCell {
    
    var link: ContactViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
////        backgroundColor = .red
//
//        // kind of cheat and use a hack
//        let starButton = UIButton(type: .system)
////        starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
//        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//
//        starButton.tintColor = .red
//        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
//
//        accessoryView = starButton
    }
    
    @objc private func handleMarkAsFavorite() {
//        print("Marking as favorite")
        link?.someMethodIWantToCall(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}








