//
//  IMainViewController.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import UIKit

protocol IMainViewController: UICollectionViewDelegate {
    
    func setupText(_ text: String)
    func getText() -> String?
}
