import SwiftUI
import AVFoundation

// UIViewRepresentable to display the camera feed
struct CameraView: UIViewRepresentable {
    class CameraViewContainer: UIView {
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupCamera()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupCamera()
        }

        func setupCamera() {
            guard let camera = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: camera) else {
                return
            }

            // Set up the session
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = .high
            captureSession?.addInput(input)

            // Set up the preview layer
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.frame = bounds
            layer.addSublayer(previewLayer!)

            // Start running the session
            captureSession?.startRunning()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = bounds
        }
    }

    func makeUIView(context: Context) -> CameraViewContainer {
        return CameraViewContainer()
    }

    func updateUIView(_ uiView: CameraViewContainer, context: Context) {
        // No updates needed for now
    }
}

// SwiftUI Preview
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

