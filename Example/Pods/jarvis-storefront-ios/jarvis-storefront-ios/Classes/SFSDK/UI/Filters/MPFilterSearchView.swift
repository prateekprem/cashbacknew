//
//  MPFilterSearchView.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 25/07/19.
//

import UIKit

class MPFilterSearchView: UIView, UISearchBarDelegate {
    var filterSearchActiveStatus: ((Bool) -> Void)?
    var refreshListWithSearchText: ((String?) -> Void)?
   
    @IBOutlet weak private var searchBar: UISearchBar!{
        didSet {
            var textFieldInsideUISearchBar: UITextField?
            if #available(iOS 13.0, *) {
                textFieldInsideUISearchBar = searchBar.searchTextField
            } else {
                textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
            }
            
            textFieldInsideUISearchBar?.textColor = UIColor.getColorFromHexValue(0x506d85, Alpha: 1.0)
            textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(12)
            let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideUISearchBarLabel?.textColor = UIColor.getColorFromHexValue(0x506d85, Alpha: 1.0)
            textFieldInsideUISearchBarLabel?.font = textFieldInsideUISearchBar?.font
        }
    }
    
    func setPlaceholder(_ placeholder: String) {
        searchBar.placeholder = "Search by \(placeholder)"
    }
    
    func hideKeyBoard() {
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        refreshListWithSearchText?(nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refreshListWithSearchText?(searchText)
    }
}
