//
//  DetailViewController.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/03.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var btnUrl: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    @IBOutlet weak var labelPages: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    public var isbn13:String = ""
    private let placeHolder = "Please Enter Note"
    
    private var book:Book? {
        willSet(newVal) {
            if let detailBook = newVal {
                self.labelTitle.text = detailBook.title
                self.labelSubtitle.text = detailBook.subtitle
                self.labelPrice.text = detailBook.price
                self.btnUrl.setTitle(detailBook.url, for: .normal)
                
                if let url = detailBook.image {
                    self.imageView.loadImage(urlString: url) {}
                }
                
                self.labelAuthor.text = detailBook.authors ?? ""
                self.labelPublisher.text = detailBook.publisher ?? ""
                self.labelPages.text = detailBook.pages ?? ""
                self.labelLanguage.text = detailBook.language ?? ""
                self.labelYear.text = detailBook.year ?? ""
                self.labelRating.text = detailBook.rating ?? ""
                self.labelDesc.text = detailBook.desc ?? ""
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isbn13 == "" {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        configView()
        loadDetailInfo(isbn13: isbn13)
    }
    
    @IBAction func tapBtnUrl(_ sender: Any) {
        if let bookUrl = book?.url {
            if let url = URL(string: bookUrl) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func loadDetailInfo(isbn13:String) {
        ApiManager.instance.reqDetailInfo(isbn13: isbn13) { (book) in
            if let book = book {
                DispatchQueue.main.async {
                    self.book = book
                }
            }
        }
    }
    
    private func configView() {
        textView.text = placeHolder
        textView.textColor = UIColor.lightGray
    }
}

extension DetailViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
}
