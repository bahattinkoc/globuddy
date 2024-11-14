//
//  Earth.swift
//  globuddy
//
//  Created by BAHATTIN KOC on 14.11.2024.
//

import SwiftUI
import SceneKit

struct Earth: UIViewRepresentable {
    @Binding var scene: SCNScene?
    @Binding var selectedFriendName: String?
    var userList: [ProfileModel]

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = scene
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.defaultCameraController.interactionMode = .orbitAngleMapping
        sceneView.antialiasingMode = .multisampling2X
        sceneView.cameraControlConfiguration.rotationSensitivity = 0.2
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSceneTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, userList: userList)
    }

    class Coordinator: NSObject {
        var parent: Earth
        var selectedNode: SCNNode?
        var userList: [ProfileModel]

        init(_ parent: Earth, userList: [ProfileModel]) {
            self.parent = parent
            self.userList = userList
        }

        @objc func handleSceneTap(_ gesture: UITapGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            guard let scnView = gesture.view as? SCNView else { return }

            let hitResults = scnView.hitTest(location, options: [:])

            if let hit = hitResults.first {
                if let nodeName = hit.node.name, userList.contains(where: { $0.imageName == nodeName }) {
                    if let previousNode = selectedNode {
                        resetNodeSize(previousNode)
                        resetGradientColor(previousNode)
                    }

                    selectedNode = hit.node
                    enlargeNode(hit.node)
                    changeGradientColorToGreen(hit.node)
                    withAnimation {
                        parent.selectedFriendName = nodeName
                    }
                }
            }
        }

        func enlargeNode(_ node: SCNNode) {
            let enlargeAction = SCNAction.scale(to: 1.5, duration: 0.2)
            if let borderNode = node.parent {
                borderNode.runAction(enlargeAction)
            }
        }

        func resetNodeSize(_ node: SCNNode) {
            let resetAction = SCNAction.scale(to: 1.0, duration: 0.2)
            if let borderNode = node.parent {
                borderNode.runAction(resetAction)
            }
        }

        func changeGradientColorToGreen(_ node: SCNNode) {
            if let borderNode = node.parent, let borderMaterial = borderNode.geometry?.firstMaterial {
                let greenGradientImage = createGradientImage(size: CGSize(width: 100, height: 100),
                                                             colors: [
                                                                 UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0),
                                                                 UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0),
                                                                 UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0),
                                                                 UIColor(red: 0.6, green: 1.0, blue: 0.6, alpha: 1.0)
                                                             ])
                borderMaterial.diffuse.contents = greenGradientImage
            }
        }

        func resetGradientColor(_ node: SCNNode) {
            if let borderNode = node.parent, let borderMaterial = borderNode.geometry?.firstMaterial {
                let originalGradientImage = createGradientImage(size: CGSize(width: 100, height: 100),
                                                                colors: [
                                                                    UIColor(red: 1.0, green: 0.0, blue: 0.66, alpha: 1.0),
                                                                    UIColor(red: 0.54, green: 0.23, blue: 0.73, alpha: 1.0),
                                                                    UIColor(red: 1.0, green: 0.86, blue: 0.50, alpha: 1.0)
                                                                ])
                borderMaterial.diffuse.contents = originalGradientImage
            }
        }

        func createGradientImage(size: CGSize, colors: [UIColor]) -> UIImage? {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(origin: .zero, size: size)
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)

            UIGraphicsBeginImageContext(size)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            gradientLayer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return image
        }
    }
}
