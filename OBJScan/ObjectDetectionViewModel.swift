//
//  ObjectDetectionViewModel.swift
//  OBJScan
//
//  Created by Ekanshh Praveen on 2024-12-19.
//

import SwiftUI
import AVFoundation
import Vision

class ObjectDetectionViewModel: ObservableObject {
    @Published var detectedObjects: [DetectedObject] = []
    
    private var detectionRequest: VNCoreMLRequest?
    
    init() {
        setupObjectDetection()
    }
    
    // Setup YOLOv3 with Vision
    func setupObjectDetection() {
        // Load the CoreML model
        guard let model = try? VNCoreMLModel(for: YOLOv3(configuration: MLModelConfiguration()).model) else {
            print("Failed to load YOLOv3 model.")
            return
        }
        
        // Create a Vision request
        detectionRequest = VNCoreMLRequest(model: model) { [weak self] request, error in
            if let results = request.results as? [VNRecognizedObjectObservation] {
                DispatchQueue.main.async {
                    self?.detectedObjects = results.map { DetectedObject(observation: $0) }
                }
            }
        }
        
        detectionRequest?.imageCropAndScaleOption = .scaleFill
    }
    
    // Process camera frames
    func processFrame(sampleBuffer: CMSampleBuffer) {
        guard let detectionRequest = detectionRequest else { return }
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .right)
        do {
            try handler.perform([detectionRequest])
        } catch {
            print("Error performing detection: \(error.localizedDescription)")
        }
    }
}

// Struct to represent detected objects
struct DetectedObject: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let boundingBox: CGRect
    
    init(observation: VNRecognizedObjectObservation) {
        self.label = observation.labels.first?.identifier ?? "Unknown"
        self.confidence = observation.labels.first?.confidence ?? 0
        self.boundingBox = observation.boundingBox
    }
}
