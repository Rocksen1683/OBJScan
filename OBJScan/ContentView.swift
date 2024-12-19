import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            CameraView()
                .edgesIgnoringSafeArea(.all) // Full screen camera preview
            VStack {
                Spacer()
                Text("Object Detection Camera")
                    .font(.headline)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}


