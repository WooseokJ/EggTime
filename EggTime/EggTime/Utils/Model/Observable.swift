//
//  Observable.swift
//  EggTime
//
//  Created by useok on 2022/10/20.
//

import Foundation



class Observable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet{
            listener?(value)
        }
    }
    init(_ val: T) {
        self.value = val
    }
    func bind(_ com: @escaping (T) -> Void) {
        com(value)
        listener = com
    }
    
}
