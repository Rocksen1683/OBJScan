import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @ObservedObject var viewModel: ObjectDetectionViewModel

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            parent.viewModel.processFrame(sampleBuffer: sampleBuffer)
        }
    }

    class CameraViewContainer: UIView {
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?

        init(frame: CGRect, delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
            self.delegate = delegate
            super.init(frame: frame)
            setupCamera()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupCamera()
        }

        func setupCamera() {
            guard let delegate = delegate else { return }
            guard let camera = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: camera) else {
                return
            }

            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = .high
            captureSession?.addInput(input)

            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "videoQueue"))
            if captureSession?.canAddOutput(videoOutput) == true {
                captureSession?.addOutput(videoOutput)
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.frame = bounds
            layer.addSublayer(previewLayer!)

            captureSession?.startRunning()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = bounds
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> CameraViewContainer {
        return CameraViewContainer(frame: .zero, delegate: context.coordinator)
    }

    func updateUIView(_ uiView: CameraViewContainer, context: Context) {}
}

// SwiftUI Preview
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(viewModel: ObjectDetectionViewModel())
    }
}

