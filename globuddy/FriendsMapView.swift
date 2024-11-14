//
//  FriendsMapView.swift
//  globuddy
//
//  Created by BAHATTIN KOC on 14.11.2024.
//

import SwiftUI
import SceneKit

struct ProfileModel {
    let imageName: String
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
}

struct Bubble: Identifiable {
    let id = UUID()
    var size: CGFloat
    var positionX: CGFloat
    var positionY: CGFloat
    var speed: Double
    var opacity: Double
}

struct FriendsMapView: View {
    @State private var bubbles: [Bubble] = []
    @State var scene: SCNScene? = .init(named: "animationEarth.usdz")
    @State private var selectedFriendName: String?
    private let userList = [
        ProfileModel(imageName: "bahattin", name: "Bahattin Koc", description: "iOS Developer", latitude: 40.7128, longitude: -74.0060),
        ProfileModel(imageName: "cook", name: "Tim Cook", description: "CEO of Apple", latitude: 35.6895, longitude: 139.6917),
        ProfileModel(imageName: "wozniak", name: "Steve Wozniak", description: "Co-founder of Apple", latitude: -33.8688, longitude: 151.2093),
        ProfileModel(imageName: "elon", name: "Elon Musk", description: "Artist", latitude: -33.9249, longitude: 18.4241),
        ProfileModel(imageName: "ironman", name: "Iron Man", description: "Billioner", latitude: -22.9068, longitude: -43.1729),
        ProfileModel(imageName: "thor", name: "Thor", description: "God of Lightning", latitude: 34.0522, longitude: -118.2437),
        ProfileModel(imageName: "hulk", name: "Bruce Banner", description: "Scientist", latitude: 51.5074, longitude: -0.1278),
        ProfileModel(imageName: "spiderman", name: "Peter Parker", description: "Neighborhood", latitude: 35.6895, longitude: 139.6917),
        ProfileModel(imageName: "camerica", name: "Steve", description: "Soldier", latitude: -33.8688, longitude: 151.2093),
        ProfileModel(imageName: "bpanter", name: "Black Panter", description: "Rich", latitude: 78.8566, longitude: 2.3522)
    ]

    var body: some View {
        ZStack {
            ZStack {
                ForEach(bubbles.indices, id: \.self) { index in
                    Circle()
                        .frame(width: bubbles[index].size, height: bubbles[index].size)
                        .position(x: bubbles[index].positionX, y: bubbles[index].positionY)
                        .opacity(bubbles[index].opacity)
                        .onAppear {
                            animateBubble(at: index)
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: createBubbles)

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
                if let friendName = selectedFriendName, let user = userList.first(where: { $0.imageName == friendName }) {
                    ProfileView(profileImage: UIImage(named: user.imageName) ?? .init(), name: user.name, description: user.description)
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: friendName)
                        .padding(.top, -15)
                }
                Spacer()
            }
            Earth(scene: $scene, selectedFriendName: $selectedFriendName, userList: userList)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        }
        .onAppear {
            userList.forEach { item in
                addLocationMarker(to: scene, model: item)
            }
        }
    }

    func createBubbles() {
        for _ in 0..<100 {
            let size = CGFloat.random(in: 5...15)
            let positionX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            let positionY = UIScreen.main.bounds.height + size
            let speed = Double.random(in: 15.0...20.0)
            let opacity = Double.random(in: 0.2...0.5)
            let bubble = Bubble(size: size, positionX: positionX, positionY: positionY, speed: speed, opacity: opacity)
            bubbles.append(bubble)
        }
    }

    func animateBubble(at index: Int) {
        let delay = Double.random(in: 0...20)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeOut(duration: bubbles[index].speed)
                .repeatForever(autoreverses: false)) {
                bubbles[index].positionY = -100
                bubbles[index].opacity = 0
            }
        }
    }

    func centerNode(_ node: SCNNode) {
        let moveAction = SCNAction.move(to: SCNVector3(0, 0, 50), duration: 1.0)
        node.runAction(moveAction)
    }

    func addLocationMarker(to scene: SCNScene?, model: ProfileModel) {
        let borderSize: CGFloat = 14.0
        let profileSize: CGFloat = 12.0

        let gradientImage = createGradientImage(size: CGSize(width: borderSize, height: borderSize), colors: [
            UIColor(red: 1.0, green: 0.0, blue: 0.66, alpha: 1.0),
            UIColor(red: 0.54, green: 0.23, blue: 0.73, alpha: 1.0),
            UIColor(red: 1.0, green: 0.86, blue: 0.50, alpha: 1.0)]
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

        let latitude: Double = model.latitude
        let longitude: Double = model.longitude

        let radius: Double = 100.0
        let offset: Double = 5.0
        let adjustedRadius = radius + offset

        let x = adjustedRadius * cos(latitude * .pi / 180) * cos(longitude * .pi / 180)
        let y = adjustedRadius * sin(latitude * .pi / 180)
        let z = adjustedRadius * cos(latitude * .pi / 180) * sin(longitude * .pi / 180)

        borderNode.position = SCNVector3(x, y, z)
        borderNode.addChildNode(profileNode)
        borderNode.constraints = [SCNBillboardConstraint()]
        scene?.rootNode.addChildNode(borderNode)
        scene?.rootNode.scale = SCNVector3(1.6,1.6,1.6)
        scene?.rootNode.position = SCNVector3(90.0, -40.0, 0)
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

#Preview {
    FriendsMapView()
}
