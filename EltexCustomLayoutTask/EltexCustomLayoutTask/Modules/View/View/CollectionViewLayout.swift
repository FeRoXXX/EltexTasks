//
//  CollectionViewLayout.swift
//  EltexCustomLayoutTask
//
//  Created by Александр Федоткин on 08.11.2024.
//

import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    
    fileprivate let cellPadding: CGFloat = 5
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 50
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    var data: CollectionData?
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true,
              let data else { return }
        showData(data: data)
        var yOffset = [CGFloat]()
        var currentColumnNumber: CGFloat = 0
        for item in 0..<data.elements.count {
            for _ in 0..<data.elements[item].count {
                yOffset.append(currentColumnNumber * cellPadding + contentHeight * currentColumnNumber)
            }
            currentColumnNumber += 1
        }
        
        
        var xOffset = [CGFloat]()
        switch data.alignment {
        case .center:
            var currentColumn = 0
            for item in 0..<data.elements.count{
                var basePadding: CGFloat = 0
                data.elements[item].forEach {
                    basePadding += (CGFloat($0.rawValue) * contentWidth)
                }
                basePadding = contentWidth / 2 - basePadding / 2
                var previousCellsWidth: CGFloat = 0
                for column in 0..<data.elements[item].count {
                    let indexPath = IndexPath(item: currentColumn, section: 0)
                    let cellWidth: CGFloat = CGFloat(data.elements[item][column].rawValue)
                    switch column {
                    case 0:
                        xOffset.append(basePadding)
                    default:
                        xOffset.append(previousCellsWidth + basePadding)
                    }
                    previousCellsWidth += cellWidth * contentWidth
                    let frame = CGRect(x: xOffset[currentColumn], y: yOffset[currentColumn], width: cellWidth * contentWidth, height: contentHeight)
                    currentColumn += 1
                    let insetFrame = frame.insetBy(dx: cellPadding / 2, dy: cellPadding / 2)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                }
            }
        case .left:
            var currentColumn = 0
            for item in 0..<data.elements.count {
                var previousCellsWidth: CGFloat = 0
                for column in 0..<data.elements[item].count {
                    let indexPath = IndexPath(item: currentColumn, section: 0)
                    let cellWidth: CGFloat = CGFloat(data.elements[item][column].rawValue)
                    switch column {
                    case 0:
                        xOffset.append(0)
                    default:
                        xOffset.append(previousCellsWidth)
                    }
                    previousCellsWidth += cellWidth * contentWidth
                    let frame = CGRect(x: xOffset[currentColumn], y: yOffset[currentColumn], width: cellWidth * contentWidth, height: contentHeight)
                    currentColumn += 1
                    let insetFrame = frame.insetBy(dx: cellPadding / 2, dy: 5)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                }
            }
        case .right:
            var currentColumn = 0
            for item in 0..<data.elements.count {
                var basePadding: CGFloat = 0
                data.elements[item].forEach {
                    basePadding += (CGFloat($0.rawValue) * contentWidth)
                }
                basePadding = contentWidth - basePadding 
                var previousCellsWidth: CGFloat = 0
                for column in 0..<data.elements[item].count {
                    let indexPath = IndexPath(item: currentColumn, section: 0)
                    let cellWidth: CGFloat = CGFloat(data.elements[item][column].rawValue)
                    switch column {
                    case 0:
                        xOffset.append(basePadding)
                    default:
                        xOffset.append(previousCellsWidth + basePadding)
                    }
                    previousCellsWidth += cellWidth * contentWidth
                    let frame = CGRect(x: xOffset[currentColumn], y: yOffset[currentColumn], width: cellWidth * contentWidth, height: contentHeight)
                    currentColumn += 1
                    let insetFrame = frame.insetBy(dx: cellPadding / 2, dy: cellPadding / 2)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    private func showData(data: CollectionData) {
        
        data.elements.forEach { (value: [Size]) in
            
            if value.isEmpty {
                fatalError()
            }
            
            if value.reduce(0.0, { $0 + $1.rawValue }) > 1 {
                fatalError()
            }
        }
    }
    
}
