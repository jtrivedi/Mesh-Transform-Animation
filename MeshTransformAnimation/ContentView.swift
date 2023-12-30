//
//  ContentView.swift
//  MeshTransformAnimation
//
//  Created by Janum Trivedi on 12/30/23.
//

import SwiftUI
import Wave

struct ContentView: View {

    @State var progress: CGFloat = 0

    let progressAnimator = SpringAnimator<CGFloat>(
        spring: .init(dampingRatio: 0.75, response: 0.8),
        value: 0,
        target: 1
    )

    var blurRadius: CGFloat {
        mapRange(progressAnimator.value ?? 0, 0, 1, 0, 8)
    }

    func shader() -> Shader {
        Shader(function: .init(library: .default, name: "distortion"), arguments: [
            .boundingRect,
            .float(progress)
        ])
    }

    var body: some View {
        ZStack {
            backgroundBlue

            Image("card")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                .shadow(color: shadowBlue.opacity(0.15), radius: 12, y: 8)
                .padding(24)
                .distortionEffect(shader(), maxSampleOffset: CGSize(width: 100, height: 200))
                .blur(radius: blurRadius)

        }
        .ignoresSafeArea(.all)
        .onTapGesture {
            guard let target = progressAnimator.target else { return }

            progressAnimator.target = (target == 0) ? 1 : 0
            progressAnimator.start()
        }
        .onAppear {
            progressAnimator.valueChanged = { value in
                self.progress = value
            }
            progressAnimator.start()
        }
    }

    var shadowBlue: Color {
        Color(hue: 0.635, saturation: 0.674, brightness: 0.614, opacity: 1.0)
    }

    var backgroundBlue: Color {
        Color(hue: 0.63, saturation: 0.071, brightness: 0.94, opacity: 1.0)
    }
}

#Preview {
    ContentView()
}
