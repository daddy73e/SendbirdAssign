//
//  SearchViewController.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/01.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar {
        return searchController.searchBar
    }
    
    private var searchResponse:SearchResponse?
    private var books = [Book]()
    private var updatedPage = 0
    private var searchedText = ""
    private var isFetching:Bool = false {
        willSet(newVal) {
            indicator.isHidden = !newVal
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configView() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.delegate = self
        searchBar.placeholder = "Search Book"
        searchBar.searchBarStyle = .default
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .white
        searchBar.setValue("Cancel", forKey: "cancelButtonText")
        definesPresentationContext = true
        
        navigationItem.title = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func updateData(searchText:String,
                            updatePage:Int) {
        if searchedText == searchText {
            if self.searchResponse?.totalValue() == books.count {
                return
            }
        }
        
        self.isFetching = true
        ApiManager.instance.reqSearchBook(name: searchText,
                                          page: updatePage) { (result) in
            if let response = result {
                self.searchResponse = response
                DispatchQueue.main.async {
                    if self.searchedText != searchText {
                        self.books.removeAll()
                        self.tableView.reloadData()
                    }
                    
                    self.books.append(contentsOf: response.books)
                    self.tableView.reloadData()
                    self.updatedPage = Int(response.page) ?? 0
                    self.searchedText = searchText
                    self.isFetching = false
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "showDetail" {
            if let book = sender as? Book {
                let destination = segue.destination as! DetailViewController
                destination.isbn13 = book.isbn13
            }
        }
    }
}

extension SearchViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        let text = searchText.replacingOccurrences(of: " ", with: "")
        if text.isEmpty {
            return
        }
        
        if let encordingTxt = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if searchedText != encordingTxt {
                updateData(searchText: encordingTxt, updatePage: 0)
            }
        }
    }
}

extension SearchViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id,
                                                    for: indexPath) as? SearchTableViewCell {
            let book = self.books[indexPath.row]
            cell.selectionStyle = .none
            cell.config(book: book)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}

extension SearchViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: book)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isFetching || self.searchedText.isEmpty {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            updateData(searchText: self.searchedText,
                       updatePage: self.updatedPage + 1)
        }
        
    }
}
