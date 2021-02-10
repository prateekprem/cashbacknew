//
//  JRFLowLayout.swift
//  jarvis-common-ios
//
//  Created by Gulshan Kumar on 15/12/20.
//

import UIKit
import jarvis_utility_ios

let JRCollectionHeaderKey:String = "JRCollectionHeaderKey"
let JRCollectionBodyKey:String = "JRCollectionBodyKey"
let JRCollectionFooterKey:String = "JRCollectionFooterKey"

//#warning Code optimization needed.
public class JRFlowLayoutAttributes: UICollectionViewLayoutAttributes {

    public var columnIndex = 0
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let attributes: JRFlowLayoutAttributes = self.copy(with: zone) as! JRFlowLayoutAttributes
        attributes.columnIndex = self.columnIndex
        return attributes
    }
   

    func description() -> String! {
        return String(format:"%@ column = %zd", self.description, self.columnIndex)
    }
}


public class JRFlowLayout: UICollectionViewFlowLayout {

    @IBOutlet public weak var delegate: UICollectionViewDelegateFlowLayout!
    
    public var verticalDividers: [UIView] = [UIView]()
    
    //If you don't specify numberOfItemsInARowInLandscape value,
    //numberOfItemsInARowInPortrait value is taken for both orientations.
    public var numberOfItemsInARowInPortrait = 0 //Default 2
    public var numberOfItemsInARowInLandscape = 0
    public var shouldShowDividerImage = false // Default No
    public var shouldInvalidateForOrientationChange = false //Default No , will automatically adjust cell size.
    public var shouldCacheInfoForOrientationChange = false //Defauly Yes, will store the previous layout info's for orientation change so 2 diff copies for Portait and landscape will be used. and this concept used only if shouldInvalidateForOrientationChange is set to Yes.
    
    private var _infoDictionary: [AnyHashable: Any]!
    private var infoDictionary: [AnyHashable: Any] {
        get {
            if (_infoDictionary == nil)
            {
                _infoDictionary = [AnyHashable: Any]()
            }
            return _infoDictionary
        }
        set { _infoDictionary = newValue }
    }
    
    private var _collectionWidth:CGFloat = 0
    private var collectionWidth:CGFloat {
        get { return _collectionWidth }
        set { _collectionWidth = newValue }
    }

    class func layoutAttributesClass() -> AnyClass {
        return JRFlowLayoutAttributes.self
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        shouldShowDividerImage = false
        shouldCacheInfoForOrientationChange = true
    }

    func getNumberOfItemsInARowInLandscape() -> Int {
        if numberOfItemsInARowInLandscape == 0 {
            numberOfItemsInARowInLandscape = numberOfItemsInARowInPortrait
        }
        return numberOfItemsInARowInLandscape
    }

    func getNumberOfItemsInARowInPortrait() -> Int {
        if numberOfItemsInARowInPortrait == 0
        {

            numberOfItemsInARowInPortrait = 1
        }
        return numberOfItemsInARowInPortrait
    }

    func orientation() -> UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    func numberOfItemsInARow() -> Int {
        if self.orientation().isLandscape {
            return self.getNumberOfItemsInARowInLandscape()
        } else {
            return self.getNumberOfItemsInARowInPortrait()
        }
    }

    // `infoDictionary` has moved as a getter.

    func collectionWidthKey() -> String {
        return shouldCacheInfoForOrientationChange ? "0" : String(format:"%d", Int(self.collectionView?.width ?? 0))
    }
    
    func layoutInfo() -> [Any]? {
        let widthKey: String = collectionWidthKey()
        if infoDictionary[widthKey] == nil {
            infoDictionary[widthKey] = [Any]()
        }
        return infoDictionary[widthKey] as? [Any]
    }
    
    //- (void)setShouldInvalidateForOrientationChange:(BOOL)shouldInvalidateForOrientationChange
    //{
    //    _shouldInvalidateForOrientationChange = shouldInvalidateForOrientationChange;
    //    if (_shouldInvalidateForOrientationChange)
    //    {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //    }
    //
    //}

    // MARK: - Info Fetching
    func sectionItemsAttributes(forSection section:Int) -> [AnyHashable: Any]? {
        if layoutInfo() == nil ||  layoutInfo()!.count > section {
            self.fetchInfoOfSection(section)
        }
        var infoCount = 0
        if let count = layoutInfo()?.count {
            infoCount = count
        }
        return infoCount < section ? nil : self.layoutInfo()?[section] as? [AnyHashable: Any]
    }

    func headerAttributes(forSection section: Int) -> JRFlowLayoutAttributes? {
        let sectionInfo = sectionItemsAttributes(forSection: section)
        return sectionInfo?[JRCollectionHeaderKey] as? JRFlowLayoutAttributes
    }

    func footerAttributes(forSection section: Int) -> JRFlowLayoutAttributes? {
        let sectionInfo = sectionItemsAttributes(forSection: section)
        return sectionInfo?[JRCollectionFooterKey] as? JRFlowLayoutAttributes
    }

    func rowItemsAttributes(forSection section: Int) -> [AnyHashable]? {
        let sectionInfo = sectionItemsAttributes(forSection: section)
        return sectionInfo?[JRCollectionBodyKey] as? [AnyHashable]
    }

    func attributiesOfItem(atRow row: Int, section: Int) -> JRFlowLayoutAttributes? {
        let sectionInfo = rowItemsAttributes(forSection: section)
        if !((sectionInfo?.count ?? 0) >= row) {
            fetchInfoOfSection(section)
        }
        var sectionInfoCount = 0
        if let count = sectionInfo?.count {
            sectionInfoCount = count
        }
        return (sectionInfoCount <= row) ? nil : sectionInfo?[row] as? JRFlowLayoutAttributes
    }
    
    func columnIndexForItemAtRow(_ row:Int, section:Int) -> Int {
        if let index = self.layoutAttributesForItemAtRow(row, section:section)?.columnIndex {
            return index
        }
        return 0
    }

    func frameForItemAtRow(_ row: Int, section:Int) -> CGRect {
        if let attribute:JRFlowLayoutAttributes = self.layoutAttributesForItemAtRow(row, section:section) {
            return attribute.frame
        }
        return CGRect.zero
    }

    func layoutAttributesForItemAtRow(_ row:Int, section:Int) -> JRFlowLayoutAttributes? {
        return self.attributiesOfItem(atRow: row, section: section)
    }


    // MARK: - Info Creation
    func createLayoutInfo(forRow row: Int, section: Int, frame: CGRect, column: Int) -> JRFlowLayoutAttributes? {
        let layoutAttributes: JRFlowLayoutAttributes = JRFlowLayoutAttributes(forCellWith: IndexPath(row: row, section: section))
        layoutAttributes.frame = frame
        layoutAttributes.columnIndex = column
        return layoutAttributes
    }

    func createLayoutForSupplementaryView(withRow row: Int, section: Int, frame: CGRect, forHeader isHeader: Bool) -> JRFlowLayoutAttributes? {
        let kind: String = isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        let layoutAttributes: JRFlowLayoutAttributes = JRFlowLayoutAttributes(forSupplementaryViewOfKind: kind, with: IndexPath(row: row, section: section))
        layoutAttributes.frame = frame
        return layoutAttributes
    }

    // MARK: - Accessory Methods

    func cellWidth() -> CGFloat {
        let spacingFactor = CGFloat(numberOfItemsInARow() + 1) * minimumInteritemSpacing
        var collectionViewWidth: CGFloat = 0
        
        if let width: CGFloat = collectionView?.width {
            collectionViewWidth = width
        }
        return (collectionViewWidth - spacingFactor) / CGFloat(numberOfItemsInARow())
    }

    func cellWidthWithOffset() -> CGFloat {
        return CGFloat(Int(cellWidth() + minimumInteritemSpacing))
    }

    func updateInfoOf(_ attribute: JRFlowLayoutAttributes?, withCellWidth width: CGFloat) {
        var rect: CGRect = .zero
        if let frame = attribute?.frame {
            rect = frame
        }
        rect = CGRect(x: minimumInteritemSpacing + (CGFloat(attribute?.columnIndex ?? 0) * width), y: rect.origin.y, width: width, height: rect.size.height)
        attribute?.frame = rect
    }

    func indexPathsForLastRows(ofSection section: Int) -> [IndexPath]? {
        let info = rowItemsAttributes(forSection: section)
        var rowCount: Int = 0
        if let count = info?.count {
           rowCount = count
        }
        return indexPathsOfItems(inArray: info, section: section, row: rowCount)
    }

    func indexPathsOfItems(atSection section: Int, row: Int) -> [IndexPath]? {
        let info = (rowItemsAttributes(forSection: section))
        let subArray = (info as NSArray?)?.subarray(with: NSRange(location: 0, length: row))

        return indexPathsOfItems(inArray: subArray as? [IndexPath], section: 0, row: row)
    }

    func indexPathsOfItems(inArray itemsList: [AnyHashable]?, section: Int, row: Int) -> [IndexPath]? {
        var indexPaths: [AnyHashable] = []
        for index in 0..<numberOfItemsInARow() {
            let newIndexPath = (itemsList as NSArray?)?.indexOfObject(options: .reverse, passingTest: { obj, idx, stop in
                return (obj as? JRFlowLayoutAttributes)?.columnIndex == index
            }) ?? 0
            if newIndexPath != NSNotFound {
                indexPaths.append(IndexPath(row: newIndexPath, section: section))
            }
        }
        return indexPaths as? [IndexPath]
    }

    func orientationChanged(notification:NSNotification!) {
       // #warning Need to handle this.
    }

    func loadNewlyAddedRowsIfAny() {
    //#warning Find a best to tackle this case.
        if collectionView != nil {
            self.fetchInfoOfSection(collectionView!.numberOfSections - 1)
        }
    }

    // MARK: - Private methods
    func fetchInfoOfSection(_ section: Int) {
        guard let collectionView = self.collectionView , section >= 0 else { return }
        
        let layoutInfoCount = layoutInfo()?.count ?? 0
        var layoutInfo = self.layoutInfo()
        for index in layoutInfoCount...section {
            layoutInfo?.append(
                [
                    JRCollectionHeaderKey: createLayoutForSupplementaryView(withRow: 0, section: index, frame: CGRect.zero, forHeader: true) as Any,
                    JRCollectionBodyKey: [Any](),
                    JRCollectionFooterKey: createLayoutForSupplementaryView(withRow: 0, section: index, frame: CGRect.zero, forHeader: false) as Any
                ]
            )
        }
        
        
        for sectionIndex in 0...section  {
            
            let sectionItemList = self.layoutInfo()?[sectionIndex] as? [AnyHashable: Any]
            let header: JRFlowLayoutAttributes? = sectionItemList?[JRCollectionHeaderKey] as? JRFlowLayoutAttributes
            let footer: JRFlowLayoutAttributes? = sectionItemList?[JRCollectionFooterKey] as? JRFlowLayoutAttributes
            var itemList: [AnyHashable]? = sectionItemList?[JRCollectionBodyKey] as? [AnyHashable]
            
            var headerSize: CGSize = .zero
            
            /********* header *********/
            //setup attributes for header
            if delegate != nil && delegate!.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForHeaderInSection:)))  {
                if let size = delegate.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: sectionIndex) {
                    headerSize = size
                }
            }
            
            let previousFooter: JRFlowLayoutAttributes? = self.footerAttributes(forSection: sectionIndex - 1)
            var prevFooterY: CGFloat = 0
            var prevFooterheight : CGFloat = 0
            if let value = previousFooter {
                prevFooterY = value.frame.origin.y
                prevFooterheight = value.frame.height
            }

            header?.frame = CGRect(x: 0.0, y:  prevFooterY + prevFooterheight, width: headerSize.width, height: headerSize.height)
            /******************/
            
            /********* Body *********/
            var itemRect: CGRect = .zero
            var itemListCount: Int = 0
            if let count = itemList?.count {
                itemListCount = count
            }
            for index in itemListCount..<collectionView.numberOfItems(inSection: sectionIndex) {
            
                var bodySize:CGSize = .zero
                if delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:sizeForItemAt:))) {
                    if let size = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: IndexPath(row: index, section: sectionIndex)) {
                        bodySize = size
                    }
                }
                
                var column:Int = 0
                if index < self.numberOfItemsInARow()
                {
                    var headerHeight : CGFloat = 0
                    var headerY : CGFloat = 0
                    if let headerCopy = header {
                        headerHeight = headerCopy.frame.size.height
                        headerY = headerCopy.frame.origin.y
                    }
    
                    itemRect = CGRect(
                        x: self.minimumInteritemSpacing + (CGFloat(index) * self.cellWidthWithOffset()),
                        y: self.minimumLineSpacing + headerHeight + headerY,
                        width: bodySize.width,
                        height: bodySize.height
                    )
                    column = index
                }
                else
                {
                    let int64Max: CGFloat = CGFloat(INT64_MAX)
                    var previousFrame:CGRect = CGRect(x: 0, y: int64Max, width: 0, height: int64Max)
                    var selectedIndex:Int = 0
                    if let indexPaths = self.indexPathsForLastRows(ofSection: sectionIndex)  {
                        for path in indexPaths {
                            
                            let previousFrame1:CGRect = self.frameForItemAtRow(path.row, section:sectionIndex)
                            
                            if previousFrame.maxY > previousFrame1.maxY {
                                previousFrame = previousFrame1
                                selectedIndex = path.row
                            }
                        }
                    }
                    
                    column = self.columnIndexForItemAtRow(selectedIndex, section:sectionIndex)
                    itemRect = CGRect(x: previousFrame.origin.x, y: (previousFrame.size.height + previousFrame.origin.y + self.minimumLineSpacing) , width: bodySize.width, height: bodySize.height)
                }
                
                if let attribute = self.createLayoutInfo(forRow: index, section:sectionIndex, frame:itemRect, column:column) {
                    itemList?.append(attribute)
                }
            }
            /******** Body **********/
            
            /********** Footer *********/
            var footerSize:CGSize = .zero
            
            //setup attributes for footer
            if delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForFooterInSection:))) {
                if let size = delegate.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: sectionIndex) {
                    footerSize = size
                }
            }
            
            if let list = sectionItemList?[JRCollectionBodyKey] as? [Any], list.count > 0 {
                var previousFrame:CGRect = .zero
                
                if let indexPaths = self.indexPathsForLastRows(ofSection: sectionIndex) {
                    for path in indexPaths {
                        let previousFrame1:CGRect = self.frameForItemAtRow(path.row, section:sectionIndex)
                        
                        if previousFrame.maxY < previousFrame1.maxY
                        {
                            previousFrame = previousFrame1
                        }
                    }
                }
                
               
                itemRect = CGRect(x: 0.0, y: (previousFrame.size.height + previousFrame.origin.y) , width: footerSize.width, height: footerSize.height)
            }
            else
            {
                var headerY: CGFloat = 0
                var headerHeight : CGFloat = 0
                if let header = header {
                    headerY = header.frame.origin.y
                    headerHeight = header.frame.size.height
                }
                itemRect = CGRect(x: 0.0, y: headerY + headerHeight , width: footerSize.width, height: footerSize.height)
            }
            
            footer?.frame = itemRect
        }
    }


    // MARK: - UICollectionViewLayoutAttributes Related
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        
        guard let collectionView = self.collectionView else {
            return nil
        }
        
        var allAttributes: [AnyHashable] = []
        
        if let layoutsInfo = layoutInfo(), !layoutsInfo.isEmpty {
            let cellWidth = cellWidthWithOffset()
            
            for sectionIndex in 0..<layoutsInfo.count {
                //If footer's Y is lesser then rect's Y, continue to next section.
                var attributes: JRFlowLayoutAttributes?
                if let dict = layoutsInfo[sectionIndex] as? [AnyHashable: Any] {
                    attributes = dict[JRCollectionFooterKey] as? JRFlowLayoutAttributes
                }
                if rect.origin.y > (attributes?.frame.maxY ?? 0.0) {
                    continue
                }
                
                //add header attributies, if exist
                if collectionView.dataSource?.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))) ?? false && delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForHeaderInSection:))) {
                    if rect.intersects(attributes?.frame ?? CGRect.zero) && (attributes?.frame.size.height != 0) {
                        if let attributes = attributes {
                            allAttributes.append(attributes)
                        }
                    }
                }
                
                var cellsAttributes = rowItemsAttributes(forSection: sectionIndex) as NSArray?
                var intersectingCellIndex = 0
                var cellIndex = 0
                if let cellsAttributes = cellsAttributes {
                    while cellIndex < cellsAttributes.count  {
                        let itemAttributes = cellsAttributes[cellIndex] as? JRFlowLayoutAttributes
                        if rect.intersects(itemAttributes?.frame ?? CGRect.zero) {
                            intersectingCellIndex = cellIndex
                            break
                        }
                        cellIndex = cellIndex + self.numberOfItemsInARow()
                    }
                }
                
                var previousFrame = CGRect.zero
                var topCellIndex = intersectingCellIndex
                
                if let paths = indexPathsOfItems(atSection: sectionIndex, row: intersectingCellIndex)  {
                    for path in paths {
                        let previousFrame1 = frameForItemAtRow(path.row, section: sectionIndex)
                        if previousFrame.origin.y > previousFrame1.origin.y {
                            previousFrame = previousFrame1
                            topCellIndex = path.row
                        }
                    }
                }
                
                //start integating from 1 row above, for safty
                topCellIndex = ((topCellIndex - numberOfItemsInARow()) < 0) ? 0 : (topCellIndex - numberOfItemsInARow())
                
                if let cellAttrs = cellsAttributes {
                    cellsAttributes = cellAttrs.subarray(with: NSRange(location: topCellIndex, length: cellAttrs.count - topCellIndex)) as NSArray
                    cellsAttributes?.enumerateObjects({ cellAttribute, idx, stop in
                        if let attribute = cellAttribute as? JRFlowLayoutAttributes {
                            if rect.intersects(attribute.frame) {
                                updateInfoOf(attribute, withCellWidth: cellWidth)
                                allAttributes.append(attribute)
                            } else if rect.maxY < (attribute.frame.origin.y) {
                                //stop = UnsafeMutablePointer<ObjCBool>(mutating: &true)
                                stop.initialize(to: true)
                            }
                        }
                        
                    })
                }
                
                if collectionView.dataSource != nil && collectionView.dataSource!.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))) && delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForFooterInSection:))) {
                    if let layoutsInfo = layoutInfo()?[sectionIndex] as? [AnyHashable: Any], let attributes = layoutsInfo[JRCollectionFooterKey] as? JRFlowLayoutAttributes  {
                        if rect.intersects(attributes.frame) && (attributes.frame.size.height != 0) {
                            allAttributes.append(attributes)
                        } else if rect.maxY < attributes.frame.origin.y {
                            break
                        }
                    }
                }
            }
        }
        
        return allAttributes as? [JRFlowLayoutAttributes]
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.layoutAttributesForItem(at: indexPath) as? JRFlowLayoutAttributes
        if attributes == nil {
            attributes = layoutAttributesForItemAtRow(indexPath.row, section: indexPath.section)
        }
        updateInfoOf(attributes, withCellWidth: cellWidthWithOffset())
        return attributes
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        if attributes != nil {
            let dictionaryKey: String = (elementKind == UICollectionView.elementKindSectionHeader) ? JRCollectionHeaderKey : JRCollectionFooterKey
            if let layoutsInfo = layoutInfo(), indexPath.section < layoutsInfo.count {
                if let layoutsInfo = layoutsInfo[indexPath.section] as? [AnyHashable: Any] {
                    attributes = layoutsInfo[dictionaryKey] as? UICollectionViewLayoutAttributes
                }
            }
        }
        return attributes
    }

    public override var collectionViewContentSize: CGSize {
        //[self loadNewlyAddedRowsIfAny];

        guard let collectionView = self.collectionView else { return .zero }
        
        if collectionView.numberOfSections == 0 {
            return CGSize.zero
        }

        var lastFooterFrame: CGRect = .zero
        if let frame = footerAttributes(forSection: collectionView.numberOfSections - 1)?.frame {
            lastFooterFrame = frame
        }
        let height = lastFooterFrame.origin.y + lastFooterFrame.size.height

        addDivider(height)
        return CGSize(width: collectionView.width, height: height)
    }

    override public func prepare() {
        super.prepare()
        self.loadNewlyAddedRowsIfAny()
    }

    func shouldInvalidateLayoutForBoundsChange(newBounds:CGRect) -> Bool {
        if _collectionWidth != newBounds.size.width
        {
            _collectionWidth = newBounds.size.width
    //        if (self.shouldInvalidateForOrientationChange)
    //        {
    //            self.layoutInfo = nil;
    //            self.infoDictionary = nil;
    //        }
            return true
        }
        return false
    }

    //- (void)invalidateLayout
    //{
    //    [super invalidateLayout];
    //    self.layoutInfo = nil;
    //    self.infoDictionary = nil;
    //}

    func invalidateFrames() {
        self.invalidateLayout()
        self.infoDictionary.removeAll()
    }
    
    func addDivider(_ height: CGFloat) {
        guard let collectionView = self.collectionView else { return }
        
        if shouldShowDividerImage && numberOfItemsInARow() == 2 {
            if verticalDividers.count < collectionView.numberOfSections {
                for _ in (verticalDividers.count - 1)..<collectionView.numberOfSections {
                    let dividerView = UIView()
                    dividerView.backgroundColor = UIColor.colorRGB(235, green: 235, blue: 235)
                    dividerView.autoresizingMask = .flexibleLeftMargin
                    verticalDividers.append(dividerView)
                    collectionView.addSubview(dividerView)
                }
            }
            let section = 0
            for view in verticalDividers {
                var headerframe: CGRect = .zero
                if let frame = headerAttributes(forSection: section)?.frame {
                    headerframe = frame
                }
                var footerframe: CGRect = .zero
                if let frame = footerAttributes(forSection: section)?.frame {
                    footerframe = frame
                }
                view.frame = CGRect(x: collectionView.width / 2.0, y: headerframe.origin.y + headerframe.size.height, width: 1, height: footerframe.origin.y - headerframe.origin.y - headerframe.size.height)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private methods

    func indexPathOfLastTopCell(atSection section: Int) -> IndexPath? {
        var finalIndexPath: IndexPath?
        let leastFrame = CGRect(x: 0.0, y: CGFloat(INT64_MAX), width: 0.0, height: 0.0)
        (indexPathsForLastRows(ofSection: section) as NSArray?)?.enumerateObjects({ path, idx, stop in
            if let indexPath = path as? IndexPath {
                let tempFrame = frameForItemAtRow(indexPath.row, section: section)
                if tempFrame.minY < leastFrame.minY {
                    finalIndexPath = indexPath
                }
            }
            
        })
        return finalIndexPath
    }

    func indexPathOfLastLowestCell(atSection section: Int) -> IndexPath? {
        var finalIndexPath: IndexPath?
        let maxFrame = CGRect.zero
        (indexPathsForLastRows(ofSection: section) as NSArray?)?.enumerateObjects({ path, idx, stop in
            
            if let indexPath = path as? IndexPath {
                let tempFrame = frameForItemAtRow(indexPath.row, section: section)
                
                if tempFrame.minY < maxFrame.minY {
                    finalIndexPath = indexPath
                }
            }
        })
        return finalIndexPath
    }

    func indexPath(inSortedArray sortedArray: [AnyHashable]?, forLeastIntersecting intersectingRect: CGRect) -> Int? {
        let searchRange = NSRange(location: 0, length: sortedArray?.count ?? 0)
        return (sortedArray as NSArray?)?.index(of: NSValue(cgRect: intersectingRect), inSortedRange: searchRange, options: .firstEqual, usingComparator: { obj1, obj2 in
            var value: NSValue? = nil
            var attributes: JRFlowLayoutAttributes? = nil
            if obj1 is NSValue {
                value = obj1 as? NSValue
                attributes = obj2 as? JRFlowLayoutAttributes
            } else {
                value = obj2 as? NSValue
                attributes = obj1 as? JRFlowLayoutAttributes
            }
            
            if let frame = value?.cgRectValue {
                guard let attributes = attributes else { return ComparisonResult.orderedDescending }
                if frame.intersects(attributes.frame) {
                    return ComparisonResult.orderedSame
                } else if frame.minY > attributes.frame.minY {
                    return ComparisonResult.orderedAscending
                } else {
                    return ComparisonResult.orderedDescending
                }
            } else {
                return ComparisonResult.orderedDescending
            }
        })
    }
        
}

