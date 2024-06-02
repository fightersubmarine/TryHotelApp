//
//  HotelScreenViewModel.swift
//  TryHotelApp
//
//  Created by Александр on 23.05.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import MapKit

private extension CGFloat {
    static let regionMeters = 1000.0
}

final class HotelScreenViewModel {
    
    // MARK: - Properties
    let networkManager = NetworkManager()
    let hotelID: BehaviorSubject<Int>
    var hotelData: Observable<HotelScreenModel>!
    
    // MARK: - Init
    
    init(hotelID: Int) {
        
        self.hotelID = BehaviorSubject<Int>(value: hotelID)
        
        self.hotelData = self.hotelID
            .flatMapLatest { [weak self] id in
                self?.networkManager.fetchDataForHotel(id: id) ?? Observable.empty()
            }
            .map { selectHotel in
                return HotelScreenModel(selectHotel: selectHotel)
            }
            .observe(on: MainScheduler.instance)
    }

    
    func updateHotelID(_ id: Int) {
        hotelID.onNext(id)
    }
    
    // MARK: - Work with image
    
    func loadImage(from imageUrl: URL, completion: @escaping (UIImage?) -> Void) {
        SDWebImageManager.shared.loadImage(with: imageUrl, options: [], progress: nil) { (image, data, error, cacheType, finished, imageUrl) in
            guard let image = image, error == nil else {
                completion(nil)
                return
            }

            let croppedRect = CGRect(x: 2, y: 2, width: image.size.width - 4, height: image.size.height - 4)
            let croppedImage = self.cropImage(image, toRect: croppedRect)
            completion(croppedImage)
        }
    }
    
    func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        guard let croppedCGImage = cgImage.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    // MARK: - Work with map
    
    func mapData(for hotel: HotelScreenModel) -> (annotation: MKPointAnnotation, region: MKCoordinateRegion) {
        let annotation = MKPointAnnotation()
        annotation.title = hotel.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: hotel.lat, longitude: hotel.lon)

        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: CGFloat.regionMeters,
                                        longitudinalMeters: CGFloat.regionMeters)
        return (annotation, region)
    }
}
