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
    @Binding var selectedItem: MKMapItem?
    @ObservedObject var sheetModel: SheetModel
    
    let tokyo = CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    // MARK: - UIViewRepresentable
    public func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(for: self, selectedItem: $selectedItem, sheetModel: sheetModel)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        if let mapRegion = self.region {
            let region = mapView.regionThatFits(mapRegion)
            
            mapView.setRegion(region, animated: true)
        }
        
        let filter = MKPointOfInterestFilter(including: poiCat)
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
        @Binding var selectedItem: MKMapItem?
        var sheetModel: SheetModel
        
        init(for context: MapView, selectedItem: Binding<MKMapItem?>, sheetModel: SheetModel) {
            self.context = context
            self._selectedItem = selectedItem
            self.sheetModel = sheetModel
            super.init()
        }
        
        // MARK: MKMapViewDelegate
        public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            return nil
        }
        
        public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.systemBlue
            return renderer
        }
        
        public func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
            mapView.removeOverlays(mapView.overlays)
        }
        
        public func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if #available(iOS 16, *) {
                guard let featureAnnotation = annotation as? MKMapFeatureAnnotation else { return }
                let featureRequest = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
                
                Task {
                    do {
                        guard let featuredItem = try await featureRequest.mapItem else { return }
                        //Direction
                        let request = MKDirections.Request()
                        request.source = await MKMapItem(placemark: MKPlacemark(coordinate: mapView.region.center, addressDictionary: nil))
                        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: featuredItem.placemark.coordinate, addressDictionary: nil))
                        request.transportType = .walking
                        
                        let direction = MKDirections(request: request)
                        direction.calculate { response, error in
                            guard let response = response, let route = response.routes.first else {
                                return
                            }
                            mapView.addOverlay(route.polyline)
                        }
                        
                        await mapView.setCenter(featureAnnotation.coordinate, animated: true)
                        selectedItem = featuredItem
                    } catch {
                        print("Error")
                    }
                }
                
                sheetModel.closeSearch()
                sheetModel.showDetails()
            }
        }
    }
}
