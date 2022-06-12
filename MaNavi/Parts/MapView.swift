//
//  _MapView.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/10.
//

import SwiftUI
import MapKit
import Combine
import UIKit

public struct MapView: UIViewRepresentable {
    
    // MARK: - Properties
    let mapType: MKMapType
    @Binding var region: MKCoordinateRegion?
    @Binding var isCardShown: Bool
    @Binding var offset: CGFloat
    @Binding var selectedItem: MKMapItem?
    
    let tokyo = CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    public init(mapType: MKMapType = .standard,
                region: Binding<MKCoordinateRegion?> = .constant(nil),
                isCardShown: Binding<Bool>,
                offset: Binding<CGFloat>,
                selectedItem: Binding<MKMapItem?>) {
        self.mapType = mapType
        self._region = region
        self._isCardShown = isCardShown
        self._offset = offset
        self._selectedItem = selectedItem
    }
    
    // MARK: - UIViewRepresentable
    public func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(for: self, isCardShown: $isCardShown, offset: $offset, selectedItem: $selectedItem)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        if let mapRegion = self.region {
            let region = mapView.regionThatFits(mapRegion)
            
            mapView.setRegion(region, animated: true)
        }
        
        let category: [MKPointOfInterestCategory] = [.school, .university, .publicTransport]
        let filter = MKPointOfInterestFilter(including: category)
        mapView.pointOfInterestFilter = filter
        
        self.configureView(mapView, context: context)
        
        return mapView
    }
    
    public func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        self.configureView(mapView, context: context)
    }
    
    // MARK: - Configuring view state
    private func configureView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        mapView.mapType = self.mapType
        
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        if #available(iOS 16, *) {
            mapView.selectableMapFeatures = .pointsOfInterest
        }
    }
    
    // MARK: - Interaction and delegate implementation
    public class Coordinator: NSObject, MKMapViewDelegate {
        
        private let context: MapView
        @Binding var isCardShown: Bool
        @Binding var offset: CGFloat
        @Binding var selectedItem: MKMapItem?
        
        init(for context: MapView, isCardShown: Binding<Bool>, offset: Binding<CGFloat>, selectedItem: Binding<MKMapItem?>) {
            self.context = context
            self._isCardShown = isCardShown
            self._selectedItem = selectedItem
            self._offset = offset
            super.init()
        }
        
        // MARK: MKMapViewDelegate
        public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            return nil
        }
        
        public func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if #available(iOS 16, *) {
                guard let featureAnnotation = annotation as? MKMapFeatureAnnotation else { return }
                let featureRequest = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
                
                Task {
                    do {
                        guard let featuredItem = try await featureRequest.mapItem else { return }
                        await mapView.setCenter(featureAnnotation.coordinate, animated: true)
                        selectedItem = featuredItem
                    } catch {
                        print("Error")
                    }
                }
                isCardShown = true
                offset = UIScreen.main.bounds.height
                withAnimation(.easeInOut) {
                    offset = UIScreen.main.bounds.height - 220
                }
            }
        }
        
    }
    
}
