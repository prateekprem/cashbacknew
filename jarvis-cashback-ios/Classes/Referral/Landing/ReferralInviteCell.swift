//
//  MoneyTransferCell.swift
//  FBSDKCoreKit
//
//  Created by Abhishek Tripathi on 27/07/20.
//

import UIKit

enum ReferralCellType {
    case detail
    case landing
    
    var isHidden: Bool {
        switch self {
        case .detail: return false
        case .landing: return true
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .detail: return .white
        case .landing: return UIColor(red: 0.0, green: 172/255.0, blue: 237/255.0, alpha: 0.06)
        }
    }
    
     var linkgroundColor: UIColor {
        switch self {
        case .detail: return  UIColor(red: 245/255.0, green: 248/255.0, blue: 250/255.0, alpha: 1.0)
        case .landing: return .white
        }
    }
    
    var leading: CGFloat {
        switch self {
        case .detail: return  24.0
        case .landing: return 16.0
        }
    }
}

enum ReferralCellState {
    case loding
    case content
    case error
    case errorMessage(_ message: String)
}


class ReferralCellViewModel: ReffralViewModel {
    
    var type: ReferralCellType = .landing
    var header: String = ""
    var title: String
    var subTitle: String
    var inviteTitle: String = "Share your invite"
    var sharinglink: String?
    var knowMoreUrl: String = ""
    var copyImage: UIImage? = UIImage(named: "")
    var sharing: [ShareViewModel] = []
    var backgroundColor: String = "#azure6"
    var identifier: ReferralCells = .invite
    var hashCode: String = ""
    var shortURL: String = ""
    var keyword: String = ""
    var campaigne: String = ""
    var isError: Bool = false
    var shareText: String = "jr_referral_link".localized
    var isFetching: Bool = false
    
    var observer: ((_ viewState: ReferralCellState) -> Void) = {_ in }
    
    init(title: String, subTitle: String, inviteTitle: String, sharinglink: String, imageName: String, type: ReferralCellType = .landing, knowMoreUrl: String, keyword: String = "", campaigne: String,shareText: String?, shortURL: String = "") {
        self.title = title
        self.subTitle = subTitle
        self.hashCode = sharinglink
        self.sharinglink = shortURL
        self.copyImage = UIImage(named: imageName)
        self.knowMoreUrl = knowMoreUrl
        self.keyword = keyword
        self.type = type
        self.campaigne = campaigne
        self.shareText = shareText ?? "jr_referral_link".localized
        self.setupSharingOptions()
    }
    
    func setupSharingOptions() {
        let whatsapp: ShareViewModel = ShareViewModel(name: "whatsapp", image: "whatsapp", schemaUrl: "whatsapp://send?text=",shareText:self.shareText)
        let message: ShareViewModel = ShareViewModel(name: "twitter", image: "twitter", schemaUrl: "twitter://post?message=",shareText:self.shareText)
        let instagram: ShareViewModel = ShareViewModel(name: "sms", image: "sms", schemaUrl: "sms:&body=",shareText:self.shareText)
        let more: ShareViewModel = ShareViewModel(name: "more", image: "more", schemaUrl: "",shareText:self.shareText)
        
        let seq = [whatsapp, message, instagram, more]
        for index in seq {
            if index.canOpenUrl {
                self.sharing.append(index)
            }
        }
        self.sharing.append(more)
    }
    
    func fetchLinkInformation(isRetry: Bool, handler: ((_ url: String?)-> Void)?) {
        if self.sharinglink == "" {
            if hashCode != "" {
                 self.observer(.loding)
                self.fetchLinkinformation(isRetry: isRetry, handler: handler)
            } else {
                self.fetchUserHashCodeInformation(isRetry: isRetry, handler: handler)
            }
        }
     }
    
    func fetchUserHashCodeInformation(isRetry: Bool, handler: ((_ url: String?)-> Void)?) {
        self.observer(.loding)
        self.isFetching = true
        JRCBServices.fetchlinkInformation(campaigne: self.campaigne) { (sucess, resp, error) in
            self.isFetching = false
            DispatchQueue.main.async {
                //  self.observer(.content)
                if let model = resp, let data = model["data"] as? JRCBJSONDictionary, let link = data["link"] as? String {
                    self.hashCode = link
                    
                    if let shortURL = data["short_url"] as? String, shortURL != "", shortURL.length > 0  {
                        self.sharinglink = shortURL
                        handler?(shortURL)
                        self.observer(.content)

                    } else {
                        self.fetchLinkinformation(isRetry: isRetry, handler: handler)
                    }
            
                } else if let mErr = error {
                    self.isError = true
                    isRetry ? self.observer(.errorMessage(mErr)) : self.observer(.error)
                } else {
                    self.isError = true
                      isRetry ? self.observer(.errorMessage(JRCBConstants.Common.kDefaultErrorMsg)) : self.observer(.error)
                 }
            }
        }

    }
    
    func fetchLinkinformation (isRetry: Bool, handler: ((_ url: String?)-> Void)?) {
        self.isFetching = true
        JRCashbackManager.shared.cashbackDelegate?.fetchRefferlLink(hashCode, completion: { (url) in
            DispatchQueue.main.async {
                self.isFetching = false
                if let urlString = url {
                    //save url
                    JRCBServices.saveShortURL(code: self.hashCode, url: urlString) { (url) in
                    }
                    self.sharinglink = urlString
                    handler?(urlString)
                    self.observer(.content)
                } else {
                    // error
                    self.isError = true
                    isRetry ? self.observer(.errorMessage(JRCBConstants.Common.kDefaultErrorMsg)) : self.observer(.error)
                }
            }
        })
    }
}

protocol ReferralLandingProtocol: class {
    
 }


protocol ReferralInviteCellProtocol: ReferralLandingProtocol {
   func didSelectReffralButton(url: String, optionName: String)
    func didSelectKnowMore(url: String?)
    func reloadTabel()
    func showToast(message: String)
    func showAlert(error: String, message: String)
    func didSelectCopy()
 }

protocol ReferralTableCells {
    func setupData(viewModel: ReffralViewModel, _ deleage: ReferralLandingProtocol)
}

class ReferralInviteCell: UITableViewCell, ReferralTableCells  {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var shareLinkLabel: UILabel!
    @IBOutlet weak var inviteTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var space: NSLayoutConstraint!
    // need to change in future due to time constraint changing this
    @IBOutlet weak var leading1: NSLayoutConstraint!
       @IBOutlet weak var leading2: NSLayoutConstraint!
     @IBOutlet weak var leading3: NSLayoutConstraint!
    
    weak var delegate: ReferralInviteCellProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ReferralCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.borderWidth = 0.5
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor(red: 139.0/255.0, green: 166.0/255.0, blue: 193.0/255.0, alpha: 0.3).cgColor
        self.registerCell()
    }
    
    func registerCell() {
        self.collectionView.register(UINib(nibName: "ShareCell", bundle: Bundle.cbBundle), forCellWithReuseIdentifier: "ShareCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
     func setupData(viewModel: ReffralViewModel, _ deleage: ReferralLandingProtocol) {
        
        if let deleage = deleage as? ReferralInviteCellProtocol {
            self.delegate = deleage
        }
        
        if let viewModel = viewModel as? ReferralCellViewModel {
            self.viewModel = viewModel
            self.titleLabel.text = viewModel.title
            self.headerLabel.text = viewModel.header
            self.inviteTitle.text = viewModel.inviteTitle
            self.headerLabel.isHidden = self.viewModel.type.isHidden
            self.headerLabel.text = self.viewModel.keyword
            
            self.contentView.backgroundColor = self.viewModel.type.backgroundColor
            self.containerView.backgroundColor = self.viewModel.type.linkgroundColor
            
            self.leading1.constant = self.viewModel.type.leading
            self.leading2.constant = self.viewModel.type.leading
            self.leading3.constant = self.viewModel.type.leading
 
            if self.viewModel.type == .landing {
                let text = viewModel.subTitle + " Know More"
                self.subtitleLabel.text = text
                self.subtitleLabel.textColor = UIColor.black
                let underlineAttriString = NSMutableAttributedString(string: text)
                let range1 = (text as NSString).range(of: " Know More")
                underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemMediumFontOfSize(16), range: range1)
                underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 80/255, green: 109/255, blue: 133/255, alpha: 1.0), range: range1)
                        let paragraphStyle = NSMutableParagraphStyle()
                       paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
                       underlineAttriString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, text.length))
                                 self.subtitleLabel.attributedText = underlineAttriString
                self.subtitleLabel.isUserInteractionEnabled = true
                self.subtitleLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(knowMoreTapped(gesture:))))
             } else {
                self.setText(text: viewModel.subTitle)
            }
            shareLinkLabel.text = viewModel.sharinglink
            self.startObserving()
            if !self.viewModel.isError && !self.viewModel.isFetching && self.viewModel.sharinglink == "" {
                self.viewModel.fetchLinkInformation(isRetry: false, handler: nil)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func setText(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.subtitleLabel.attributedText = attributedString
    }
    
    func startObserving() {
        self.viewModel.observer = { [weak self] state in
            switch state {
            case .loding:
                self?.shareLinkLabel.cbAddLoadingView()
            case .content:
                self?.shareLinkLabel.cbRemoveLoadingView()
                 self?.delegate?.reloadTabel()
            case .error:
                self?.shareLinkLabel.cbRemoveLoadingView()
                self?.heightConstraint.constant = 0
                self?.space.constant = 0
                self?.delegate?.reloadTabel()
            case .errorMessage(let message):
                self?.shareLinkLabel.cbRemoveLoadingView()
                self?.delegate?.showAlert(error: "Error", message: message)
                break
            }
        }
    }
    
    @objc func knowMoreTapped(gesture: UITapGestureRecognizer) {
        let text = viewModel.subTitle + " Know More"
        let termsRange = (text as NSString).range(of: " Know More")
        if gesture.didTapAttributedTextInLabel(label: self.subtitleLabel, inRange: termsRange) {
            self.delegate?.didSelectKnowMore(url: self.viewModel.knowMoreUrl)
        }
    }
    
    @IBAction func tapToCopy(_ sender: UIButton) {
        self.delegate?.didSelectCopy()
        if let link = self.viewModel.sharinglink {
            UIPasteboard.general.string = link
            self.delegate?.showToast(message: "Copied")
        } else {
          self.delegate?.showToast(message: "Fetching")
        }
    }
  }

extension ReferralInviteCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.sharing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.viewModel.sharing[indexPath.row]
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ShareCell", for: indexPath) as! ShareCell
        cell.setupData(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.viewModel.sharing[indexPath.row]
        if let link = self.viewModel.sharinglink {
            let absoluteText = data.getShareUrl(text: link)
                 self.delegate?.didSelectReffralButton(url: data.name == "more" ? link :absoluteText, optionName: data.name)
         } else {
             self.viewModel.fetchLinkInformation(isRetry: true, handler: { val in
                if let link = val {
                    let absoluteText = data.getShareUrl(text: link)
                    self.delegate?.didSelectReffralButton(url: data.name == "more" ? link :absoluteText, optionName: data.name)
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 56)
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18.0
    }
    
    
}
