//
//  JRGenericPopupView.swift
//  jarvis-common-ios
//
//  Created by Shivam Jaiswal on 18/12/20.
//

import UIKit

private struct Constants {
    static let POPUP_TABLEVIEW_CELL_IDENTIFIER = "PopupTableViewCell"
    static let POPUP_TABLE_VIEW_CELL_NIB_NAME = "JRGenericPopupCell"
    
    static let BOARDING_POINT_TABLE_VIEW_CELL_LABEL_TAG = 30
    static let BOARDING_POINT_TABLE_VIEW_CELL_ImageView_TAG = 31
    
    static let DEFAULT_HEIGHT: CGFloat = 30
    static let DEFAULT_ROW_HEIGHT: CGFloat = 30
    static let MARGIN_FROM_TOP_AND_BOTTOM: CGFloat = 100.0
}

public protocol JRGenericPopupViewDelegate: AnyObject {
    func dismissPopupView()
    func didTapOkButton(_ sender: UIButton, withSelectedIndex index: Int)
}

public class JRGenericPopupView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var itemListTableView: UITableView!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewWidthConstraint: NSLayoutConstraint!
    
    public weak var delegate: JRGenericPopupViewDelegate?
    
    public var items: [String] = [] {
        willSet {
            okButton.isEnabled = false
        }
        
        didSet {
            if needDynamicHeight {
                tableViewHeightConstraint.constant = (((CGFloat(items.count) * Constants.DEFAULT_ROW_HEIGHT) + Constants.DEFAULT_HEIGHT) < tableViewHeightConstraint.constant) ? (CGFloat(items.count) * Constants.DEFAULT_ROW_HEIGHT) + Constants.DEFAULT_HEIGHT : tableViewHeightConstraint.constant
            }
            itemListTableView.reloadData()
        }
    }
    
    public var popupTitle = "" {
        didSet {
            let popupTitle = self.popupTitle as NSString
            if !popupTitle.isBlank() {
                headingLabel.text = self.popupTitle.localized
            }
        }
    }
    
    public var needDynamicHeight = false //Make it as YES if you want the pop up view height should change on the number of items it has.
    public var selectedIndexPath: IndexPath!

    public class func instance(withOwner owner: Any?) -> JRGenericPopupView? {
        Bundle(for: self).loadNibNamed("JRGenericPopupView", owner: owner, options: nil)?.first as? JRGenericPopupView
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor(white: 0.0, alpha: 0.65)
        containerView?.layer.cornerRadius = 8.0
        width = JRSwiftConstants.windowWidth
        height = JRSwiftConstants.windowHeigth

        itemListTableView.register(
            UINib(nibName: Constants.POPUP_TABLE_VIEW_CELL_NIB_NAME, bundle: Bundle(for: JRGenericPopupView.self)),
            forCellReuseIdentifier: Constants.POPUP_TABLEVIEW_CELL_IDENTIFIER)
        itemListTableView.tableFooterView = UIView(frame: CGRect.zero)

        itemListTableView.rowHeight = UITableView.automaticDimension
        itemListTableView.estimatedRowHeight = 40
        containerView?.center = center
        self.addTapGesture()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    // MARK: - UITableView Data Source and Delegate Methods

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: JRGenericPopupViewTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: Constants.POPUP_TABLEVIEW_CELL_IDENTIFIER) as? JRGenericPopupViewTableViewCell

        if cell == nil {
            cell = Bundle(for: JRGenericPopupView.self).loadNibNamed(Constants.POPUP_TABLE_VIEW_CELL_NIB_NAME, owner: self, options: nil)?.last as? JRGenericPopupViewTableViewCell
        }
        cell?.isCellSelected = ((selectedIndexPath != nil) && (indexPath.row == selectedIndexPath.row)) ? true : false
        if cell?.isCellSelected ?? false {
            okButton.isEnabled = true
        }
        cell?.titleTextLabel.text = items[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        okButton.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as? JRGenericPopupViewTableViewCell
        cell?.isCellSelected = !(cell?.isCellSelected ?? false)
        if selectedIndexPath != nil {
            let previouslySelectedCell = tableView.cellForRow(at: selectedIndexPath) as? JRGenericPopupViewTableViewCell
            previouslySelectedCell?.isCellSelected = !(previouslySelectedCell?.isCellSelected ?? false)
        }
        selectedIndexPath = indexPath
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //to hide separator for last cell
        if indexPath.row == items.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: tableView.bounds.size.width + tableView.bounds.size.height, bottom: 0.0, right: 0.0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
    // MARK: UIGestureRecognizerDelegate Method
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let containerView = containerView {
            if touch.view?.isDescendant(of: containerView) ?? false {
                // Don't let selections of auto-complete entries fire the
                // gesture recognizer
                return false
            }
        }

        return true
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        if (selectedIndexPath == nil) {
            let locVal1 = "jr_ac_pleasePercent".localized
            let message = (popupTitle as NSString).isBlank() ? "\(locVal1),\(popupTitle.lowercased())" : "jr_ac_pleaseChooseOneItem".localized
            JRAlertViewWithBlock.showAlertView("jr_ac_errorWithExclamation".localized,
                                               message: message,
                                               cancelButtonTitle: "jr_ac_OK".localized,
                                               otherButtonTitles: nil, handler: nil)
        }
        delegate?.didTapOkButton(sender, withSelectedIndex: selectedIndexPath.row)
    }

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        delegate?.dismissPopupView()
    }
}
