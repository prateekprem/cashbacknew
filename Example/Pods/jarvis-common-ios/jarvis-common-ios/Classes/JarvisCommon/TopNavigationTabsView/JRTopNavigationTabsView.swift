//
//  JRTopNavigationTabsView.swift
//  Jarvis
//
//  Created by Alok Rao on 12/05/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit


@objc public protocol JRTopNavigationTabsViewDelegate:class {
    func topNavigationTabsView(_ tabsView: JRTopNavigationTabsView, clickedAtIndex:Int)
}

@objcMembers
public final class TabCellRegisterModel:NSObject {
    var nib: UINib?
    var reuseID:String?
    public init(nib:UINib?, reuseIdentifier rId:String?) {
        super.init()
        self.nib = nib
        self.reuseID = rId
    }
}

// Delegate to provide cell nibs. It's for simple cell Provide purpose.
@objc public protocol JRTopNavigationTabsCellProviderDelegate: class {
    func registerCell(_ tabsView: JRTopNavigationTabsView) -> [TabCellRegisterModel]
    func reuseIdentifier(_ tabsView: JRTopNavigationTabsView, forIndexPath: IndexPath) -> String
    func cell(_ tabsView: JRTopNavigationTabsView, sizeForIndexPath: IndexPath) -> CGSize
}

public enum JRTopNavigationTabsCellType: Int {
    case radio
    case selection
}

public class JRTopNavigationTabInput {
    public var colorDeselectedTitle: UIColor = UIColor(white: 74.0/255.0, alpha: 1.0)
    public var colorSelectedTitle: UIColor = UIColor.appColor()
    public var selectedRadioImageFileName = "Recharge_radio_button_Selected"
    public var deSelectedRadioImageFileName = "Recharge_radio_button_deselected"
    public var selectedFont = UIFont.fontMediumOf(size: 14)
    public var deSelectedFont = UIFont.fontMediumOf(size: 14)
    public var bottomDividerConstant:CGFloat = 10.0
    public var isUpperCase: Bool = false
}

open class JRTopNavigationTabsView: UIView {
    
    @objc open weak var delegate: JRTopNavigationTabsViewDelegate?
    open weak var cellProviderDelegate: JRTopNavigationTabsCellProviderDelegate? {
        didSet{
            registerCells()
        }
    }
    
    @objc open var tabs:NSArray? = NSArray(){
        didSet {
            self.reloadCollectionView()
        }
    }
    open var shouldShowFullCellWidth : Bool = false
    open var tabWidth:CGFloat = 0
    public var equallySpaced:Bool = false
    public var type: JRTopNavigationTabsCellType = .selection
    public let input = JRTopNavigationTabInput()
    
    @available(*, deprecated) // Use JRTopNavigationTabInput
    public var colorDeselectedTitle: UIColor? {
        get {
            return input.colorDeselectedTitle
        }
        set {
            if let color = colorDeselectedTitle {
                input.colorDeselectedTitle = color
            }
        }
    }

    @available(*, deprecated) // Use JRTopNavigationTabInput
    public var colorSelectedTitle: UIColor? {
        get {
            return input.colorSelectedTitle
        }
        set {
            if let color = colorSelectedTitle {
                input.colorSelectedTitle = color
            }
        }
    }
    
    @available(*, deprecated) // Use JRTopNavigationTabInput
    public var selectedRadioImageFileName: String? {
        get {
            return input.selectedRadioImageFileName
        }
        set {
            if let name = selectedRadioImageFileName {
                input.selectedRadioImageFileName = name
            }
        }
    }
    
    @available(*, deprecated) // Use JRTopNavigationTabInput
    public var deSelectedRadioImageFileName: String? {
        get {
            return input.deSelectedRadioImageFileName
        }
        set {
            if let name = deSelectedRadioImageFileName {
                input.deSelectedRadioImageFileName = name
            }
        }
    }
    
    fileprivate var selectedIndexPath:IndexPath?
    fileprivate var widthOfTabIfEquallySpaced:CGFloat = 0.0
    
    @IBOutlet open var collectionView:UICollectionView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.createViews()
    }
    
    @objc open func selectItemAtIndex(_ index:NSInteger) {
        if let tabsCount = tabs?.count, index < tabsCount {
            let indexPath:IndexPath = IndexPath(item: index, section: 0)
            selectItemAtIndexPath(indexPath)
        }
    }
    
    open func bringSelectedTabToCenter(){
        if let selectedIndexPath = selectedIndexPath {
            self.collectionView.scrollToItem(at: selectedIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
}

extension JRTopNavigationTabsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var returnCell:UICollectionViewCell!
        guard nil == cellProviderDelegate else {
            let reuseId = cellProviderDelegate!.reuseIdentifier(self, forIndexPath: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! JRTopNavigationTabsBaseCell
            if let tabs = tabs {
                cell.model = tabs[indexPath.row] as? JRTopNavigationTabModel
            }
            return cell
        }
        
        if type == .selection {
            let cell: JRTopNavigationTabsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JRTopNavigationTabsCollectionViewCell", for: indexPath) as! JRTopNavigationTabsCollectionViewCell
            cell.input = input
            cell.shouldShowFullCellWidth = shouldShowFullCellWidth
            cell.model = tabs![indexPath.row] as! JRTopNavigationTabModel
            returnCell = cell
        } else {
            let cell: JRTopNavigationTabsRadioCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JRTopNavigationTabsRadioCollectionViewCell", for: indexPath) as! JRTopNavigationTabsRadioCollectionViewCell
            cell.input = input
            cell.model = tabs![indexPath.row] as! JRTopNavigationTabModel
            returnCell = cell
        }

        return returnCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectItemAtIndexPath(indexPath)
        self.delegate?.topNavigationTabsView(self, clickedAtIndex: indexPath.row)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabs!.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard nil == cellProviderDelegate else {
            let size = cellProviderDelegate!.cell(self, sizeForIndexPath: indexPath)
            return size
        }
        
        var size: CGSize = CGSize(width: tabWidth, height: self.frame.size.height)
        
        if tabWidth <= 0 {
            let model:JRTopNavigationTabModel = tabs![indexPath.row] as! JRTopNavigationTabModel
            
            var title:String? = model.title
            if self.input.isUpperCase {
                title = title?.uppercased()
            }
            
            if let _ = tabs, equallySpaced, frame.size.width > 0 {
                size = CGSize(width: widthOfTabIfEquallySpaced, height: self.frame.size.height)
            } else {
                var width = getWidthForTitle(title!)
                if type == .radio {
                    width += 25
                }
                
                size = CGSize(width: width, height: self.frame.size.height)
            }
        }
        
        return size
    }
    
    fileprivate func calculateWidthIfEquallySpaced() {
        
        var calculatedWidth:CGFloat = 0
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        if let tabs = tabs, tabs.count > 0, equallySpaced, let flowLayout = flowLayout {
            let spacing = flowLayout.minimumLineSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right
            let tabsCount = CGFloat(tabs.count)
            let totalWidth = JRSwiftConstants.windowWidth - ((tabsCount - 1) * spacing)
            calculatedWidth = totalWidth/tabsCount
            if false == tabFitsWithinGiven(width: calculatedWidth) {
                calculatedWidth = getWidthOfBigTab()
            }
        }
        
        widthOfTabIfEquallySpaced = calculatedWidth
    }
    
    private func getWidthOfBigTab() -> CGFloat {
        var width:CGFloat = 0
        
        guard let tabs = tabs else {
            return width
        }
        
        for model in tabs {
            let tabModel: JRTopNavigationTabModel = model as! JRTopNavigationTabModel
            if let title = tabModel.title {
                let tabWidth = getWidthForTitle(title)
                if tabWidth > width {
                    width = tabWidth
                }
            }
        }
        return width
    }
    
    private func tabFitsWithinGiven(width:CGFloat) -> Bool {
        var fits:Bool = true
        
        guard let tabs = tabs else {
            return fits
        }
        
        for model in tabs {
            let tabModel: JRTopNavigationTabModel = model as! JRTopNavigationTabModel
            let calculatedWidth = width
            
            if let title = tabModel.title {
                let tabWidth = getWidthForTitle(title)
                if tabWidth > calculatedWidth {
                    fits = false
                    break
                }
            }
        }
        return fits
    }
}

private extension JRTopNavigationTabsView {
    
    func createViews() {
        
        // First create Flow Layout
        
        if nil == collectionView {
            
            let collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
            collectionViewFlowLayout.minimumInteritemSpacing = 0
            collectionViewFlowLayout.minimumLineSpacing = 0
            collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0,left: 6,bottom: 0,right: 6)
            
            // Create collection view
            collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: collectionViewFlowLayout)
            collectionView.backgroundColor = UIColor.clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            self.addSubview(collectionView)
            
            
            
            // Define constraints
            self.translatesAutoresizingMaskIntoConstraints = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let views = ["collectionView":collectionView!]
            
            let constraints:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
            let horizontalConstraints:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
            self.addConstraints(constraints)
            self.addConstraints(horizontalConstraints)
            
        }
        
        // Register cell
        registerCells()
    }
    
    private func registerCells() {
        if let cellProviderDelegate = cellProviderDelegate {
            let models = cellProviderDelegate.registerCell(self)
            for model in models {
                if let nib = model.nib, let reuseID = model.reuseID {
                    register(nib: nib, reuseId: reuseID)
                }
            }
        } else {
            register(nibName: "JRTopNavigationTabsCollectionViewCell", reuseId: "JRTopNavigationTabsCollectionViewCell")
            register(nibName: "JRTopNavigationTabsRadioCollectionViewCell", reuseId: "JRTopNavigationTabsRadioCollectionViewCell")
        }
    }
    
    private func register(nibName: String, reuseId: String) {
        let nib1:UINib = UINib(nibName: nibName, bundle: Bundle.framework)
        collectionView.register(nib1, forCellWithReuseIdentifier: reuseId)
    }
    
    private func register(nib: UINib, reuseId: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: reuseId)
    }
    
    func reloadCollectionView() {
        var selectedIndex:Int?
        var index:Int = 0
        guard let tabs = tabs else {
            collectionView.reloadData()
            return
        }
        calculateWidthIfEquallySpaced()
        for model in tabs {
            let tabModel: JRTopNavigationTabModel = model as! JRTopNavigationTabModel
            if tabModel.selected {
                tabModel.selected = false
                selectedIndex = index
            }
            index += 1
        }
        if let selectedIndex = selectedIndex, selectedIndex < tabs.count {
            (tabs[selectedIndex] as! JRTopNavigationTabModel).selected = true
            self.selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
        }
        DispatchQueue.main.async { () -> Void in
            self.collectionView.reloadData()
        }
    }
    
    func getWidthForTitle(_ title: String) -> CGFloat {
        let titleString:NSString = title as NSString
        let size: CGSize = titleString.size(withAttributes: [NSAttributedString.Key.font: input.selectedFont])
        return size.width + 20
    }
    
    func selectItemAtIndexPath(_ indexPath: IndexPath) {
        
        // Select Item
        
        if indexPath == selectedIndexPath {
            return
        }
        
        if let tabs = tabs {
            for model in tabs {
                let tabModel: JRTopNavigationTabModel = model as! JRTopNavigationTabModel
                tabModel.selected = false
            }
        }
        
        (tabs![indexPath.row] as! JRTopNavigationTabModel).selected = true
        selectedIndexPath = indexPath
        reloadCollectionView()
        
        self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
}
