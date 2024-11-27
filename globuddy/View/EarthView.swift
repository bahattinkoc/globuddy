//
//  EarthView.swift
//  globuddy
//
//  Created by BAHATTIN KOC on 14.11.2024.
//

import SwiftUI
import SceneKit

struct EarthView: UIViewRepresentable {

    // MARK: - PROPERTIES

    @Binding var scene: SCNScene?
    @Binding var selectedFriendName: String?
    var userList: [ProfileModel]

    // MARK: - INTERNAL FUNCTIONS

    func updateUIView(_ uiView: SCNView, context: Context) { }

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

    func makeCoordinator() -> Coordinator {
        Coordinator(self, userList: userList)
    }
}

final class Coordinator: NSObject {

    // MARK: - PROPERTIES

    var parent: EarthView
    var selectedNode: SCNNode?
    var userList: [ProfileModel]

    // MARK: - INIT

    init(_ parent: EarthView, userList: [ProfileModel]) {
        self.parent = parent
        self.userList = userList
    }

    // MARK: - PRIVATE FUNCTIONS

    private func changeNodeSize(_ node: SCNNode, scale: CGFloat) {
        let resetAction = SCNAction.scale(to: scale, duration: 0.2)
        if let borderNode = node.parent {
            borderNode.runAction(resetAction)
        }
    }

    private func changeUserBackgroundColor(_ node: SCNNode, color: [UIColor]) {
        if let borderNode = node.parent,
           let borderMaterial = borderNode.geometry?.firstMaterial {
            let greenGradientImage = GradientHelper.createGradientImage(colors: color)
            borderMaterial.diffuse.contents = greenGradientImage
        }
    }

    // MARK: - ACTIONS

    @objc func handleSceneTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: gesture.view)
        guard let scnView = gesture.view as? SCNView else { return }
        let hitResults = scnView.hitTest(location, options: [:])
        if let hit = hitResults.first {
            if let nodeName = hit.node.name, userList.contains(where: { $0.imageName == nodeName }) {
                if let previousNode = selectedNode {
                    changeNodeSize(previousNode, scale: 1.0)
                    changeUserBackgroundColor(previousNode, color: GradientHelper.unselectedUserBackgroundColor)
                }
                selectedNode = hit.node
                changeNodeSize(hit.node, scale: 1.5)
                changeUserBackgroundColor(hit.node, color: GradientHelper.selectedUserBackgroundColor)
                withAnimation {
                    parent.selectedFriendName = nodeName
                }
            }
        }
    }
}
