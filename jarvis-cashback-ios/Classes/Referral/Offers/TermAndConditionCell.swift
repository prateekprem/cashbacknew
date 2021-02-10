//
//  TermAndConditionCell.swift
//  FBSDKCoreKit
//
//  Created by Abhishek Tripathi on 06/08/20.
//

import UIKit

class TermAndConditionViewModel: ReffralViewModel {
    var title: String
    var subTitle: String
    var inviteTitle: String
    var identifier: ReferralCells = .tnc
    
    init(title: String, subTitle: String, inviteTitle: String) {
        self.title = title
        self.subTitle = subTitle
        self.inviteTitle = inviteTitle
    }
}

class TermAndConditionCell: UITableViewCell, ReferralTableCells {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var title: UILabel!
    
    var viewModel: TermAndConditionViewModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(viewModel: ReffralViewModel, _ deleage: ReferralLandingProtocol) {
        if let tnc = viewModel as? TermAndConditionViewModel {
            self.viewModel = tnc
            self.textView.setHTML(html: tnc.subTitle)
            self.title.text = self.viewModel.title
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
