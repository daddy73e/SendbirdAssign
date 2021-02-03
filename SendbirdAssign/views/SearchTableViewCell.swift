//
//  SearchTableViewCell.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/02.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let id:String = "SearchTableViewCell"
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelUrl: UILabel!
    @IBOutlet weak var imageBook: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func config(book:Book) {
        labelTitle.text = book.title
        labelSubTitle.text = book.subtitle
        labelPrice.text = book.price
        labelUrl.text = book.url
        if let url = book.image {
            imageBook.loadImage(urlString: url) {}
        }
    }

}
