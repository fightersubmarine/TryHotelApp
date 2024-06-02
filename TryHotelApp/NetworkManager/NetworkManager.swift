//
//  NetworkManager.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class NetworkManager {
    
    func fetchData() -> Observable<[Hotel]> {
        let url = "https://raw.githubusercontent.com/fightersubmarine/TryHotelApi/main/firstData.json"
        
        return Observable.create { observer in
            AF.request(url).responseDecodable(of: [Hotel].self) { response in
                switch response.result {
                case .success(let hotel):
                    observer.onNext(hotel)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchDataForHotel(id: Int) -> Observable<SelectHotel> {
        let url = "https://raw.githubusercontent.com/fightersubmarine/TryHotelApi/main/\(id).json"
        
        return Observable.create { observer in
            AF.request(url).responseDecodable(of: SelectHotel.self) { response in
                switch response.result {
                case .success(let selectHotel):
                    observer.onNext(selectHotel)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
