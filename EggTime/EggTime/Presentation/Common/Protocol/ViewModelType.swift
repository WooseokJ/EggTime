//
//  ViewModelType.swift
//  EggTime
//
//  Created by useok on 2022/11/06.
//

import Foundation
import RxSwift

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output

    
}
