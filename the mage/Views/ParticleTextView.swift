import SwiftUI

struct ParticleTextView: View {
    var text: String
    var isAnimating: Bool
    
    @State private var start = Date.now
    @State private var flowMap: Image
    @State private var progress: CGFloat
    @State private var didInitialize: Bool = false
    @State private var size: CGSize = .zero
    
    init(_ text: String, animate: Bool = false) {
        self.text = text
        self.flowMap = makePerlinImage(width: 32, height: 32, scale: 20)!
        self.isAnimating = animate
        _progress = State(initialValue: animate ? 1.0 : 0.0)
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = start.distance(to: timeline.date)
            let progress = progress
            let flowMap = flowMap
            VStack {
                Text(text)
                    .padding(16)
                    .visualEffect{ content, proxy in
                        return content.distortionEffect(ShaderLibrary.particlesFlow(
                            .float(time),
                            .float(progress),
                            .float2(proxy.size),
                            .image(flowMap)
                        ), maxSampleOffset: .zero, isEnabled: true)
                    }
                    .sizeReader { size in
                        if (!didInitialize || size != self.size) {
                            didInitialize = true
                            self.flowMap = makePerlinImage(width: Int(size.width), height: Int(size.height), scale: 4)!
                        }
                    }
                    .padding(-16)
            }
        }
        .onChange(of: isAnimating) { _, newValue in
            withAnimation(.easeOut(duration: 1.0)) {
                progress = newValue ? 1 : 0
            }
        }
    }
}

#Preview {
    @Previewable @State var isOn = false
    ParticleTextView("Hello World", animate: isOn)
        .font(.system(size: 72, weight: .black))
        .onTapGesture {
            isOn.toggle()
        }
}
