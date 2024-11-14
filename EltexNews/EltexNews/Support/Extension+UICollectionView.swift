//
//  Extension+UICollectionView.swift
//  EltexNews
//
//  Created by Александр Федоткин on 14.11.2024.
//

import UIKit
import Combine

extension UICollectionView {
    
    struct SelectionPublisher: Publisher {
            typealias Output = IndexPath
            typealias Failure = Never
            
            private let collectionView: UICollectionView
            
            init(collectionView: UICollectionView) {
                self.collectionView = collectionView
            }
            
            func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, IndexPath == S.Input {
                let subscription = SelectionSubscription(subscriber: subscriber, collectionView: collectionView)
                subscriber.receive(subscription: subscription)
            }
            
            private final class SelectionSubscription<S: Subscriber>: NSObject, Subscription, UICollectionViewDelegate where S.Input == IndexPath, S.Failure == Never {
                private var subscriber: S?
                private weak var collectionView: UICollectionView?
                
                init(subscriber: S, collectionView: UICollectionView) {
                    self.subscriber = subscriber
                    self.collectionView = collectionView
                    super.init()
                    collectionView.delegate = self
                }
                
                func request(_ demand: Subscribers.Demand) {}
                
                func cancel() {
                    subscriber = nil
                    collectionView?.delegate = nil
                }
                
                func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                    _ = subscriber?.receive(indexPath)
                }
            }
        }
    
    var selectionPublisher: SelectionPublisher {
        return SelectionPublisher(collectionView: self)
    }
}
