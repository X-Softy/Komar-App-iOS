//
//  Publisher+Extension.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Combine

extension Publisher {
    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable where Self.Failure == ErrorEntity {
        sink(receiveCompletion: { subscriptionCompletion in
            if case .failure(let error) = subscriptionCompletion {
                completion(.failed(error))
            }
        }, receiveValue: { value in
            completion(.loaded(value))
        })
    }
}
