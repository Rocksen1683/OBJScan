import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ObjectDetectionViewModel()

    var body: some View {
        ZStack {
            // Pass the view model to the camera view
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)

            // Overlay detected objects as bounding boxes
            ForEach(viewModel.detectedObjects) { object in
                let screen = UIScreen.main.bounds
                let box = object.boundingBox
                let width = box.width * screen.width
                let height = box.height * screen.height
                let x = box.minX * screen.width
                let y = (1 - box.maxY) * screen.height // Flip y-axis

                Rectangle()
                    .stroke(Color.red, lineWidth: 2)
                    .frame(width: width, height: height)
                    .position(x: x + width / 2, y: y + height / 2)

                Text("\(object.label) (\(String(format: "%.2f", object.confidence)))")
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.6))
                    .position(x: x + width / 2, y: y - 15)
            }
        }
    }
}

