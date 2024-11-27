//
//  FriendsMapView.swift
//  globuddy
//
//  Created by BAHATTIN KOC on 14.11.2024.
//

import SwiftUI
import SceneKit

struct FriendsMapView: View {

    // MARK: - PROPERTIES

    @State private var scene: SCNScene? = .init(named: "animationEarth.usdz")
    @State private var selectedFriendName: String?

    var body: some View {
        ZStack {
            BubblesView()

            VStack {
                VStack {
                    Text("Hello, Bahattin")
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Your\nFriends Map")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 50)
                .padding(.leading, 20)

                if let selectedFriendName,
                   let user = MockHelper.mockUserList.first(where: { $0.imageName == selectedFriendName }) {
                    ProfileView(profileImage: UIImage(named: user.imageName) ?? .init(), name: user.name, description: user.description)
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: selectedFriendName)
                        .padding(.top, -15)
                }

                Spacer()
            }

            EarthView(scene: $scene, selectedFriendName: $selectedFriendName, userList: MockHelper.mockUserList)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        }
        .onAppear {
            MockHelper.mockUserList.forEach { item in
                if let scene {
                    addLocationMarker(to: scene, model: item)
                }
            }
        }
    }

    // MARK: - PRIVATE FUNCTIONS

    private func addLocationMarker(to scene: SCNScene, model: ProfileModel) {
        let borderSize = 14.0
        let profileSize = 12.0
        let gradientImage = GradientHelper.createGradientImage(
            size: .init(width: borderSize, height: borderSize),
            colors: GradientHelper.unselectedUserBackgroundColor
        )

        let borderPlane = SCNPlane(width: borderSize, height: borderSize)
        let borderNode = SCNNode(geometry: borderPlane)
        borderPlane.firstMaterial?.diffuse.contents = gradientImage
        borderPlane.cornerRadius = borderSize / 2

        let profilePicture = UIImage(named: model.imageName)
        let profilePlane = SCNPlane(width: profileSize, height: profileSize)
        let profileNode = SCNNode(geometry: profilePlane)
        profileNode.name = model.imageName
        profilePlane.firstMaterial?.diffuse.contents = profilePicture
        profilePlane.cornerRadius = profileSize / 2

        profileNode.position = SCNVector3(0, 0, 0.1)

        let latitude = model.latitude
        let longitude = model.longitude
        let radius = 100.0
        let offset = 5.0
        let adjustedRadius = radius + offset

        let x = adjustedRadius * cos(latitude * .pi / 180) * cos(longitude * .pi / 180)
        let y = adjustedRadius * sin(latitude * .pi / 180)
        let z = adjustedRadius * cos(latitude * .pi / 180) * sin(longitude * .pi / 180)

        borderNode.position = SCNVector3(x, y, z)
        borderNode.addChildNode(profileNode)
        borderNode.constraints = [SCNBillboardConstraint()]

        scene.rootNode.addChildNode(borderNode)
        scene.rootNode.scale = SCNVector3(1.6, 1.6, 1.6)
        scene.rootNode.position = SCNVector3(90.0, -40.0, 0)
    }
}

#Preview {
    FriendsMapView()
}
