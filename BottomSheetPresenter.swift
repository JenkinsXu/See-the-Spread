//
//  File.swift
//  See the Spread
//
//  Created by Yongqi Xu on 2022-01-29.
//

import SwiftUI

/// The code in this `struct` is extracted from and modified based on Donny Wals' [Using UISheetPresentationController in SwiftUI](https://www.donnywals.com/using-uisheetpresentationcontroller-in-swiftui/). I did NOT implemented this by myself.
struct BottomSheetPresenter<Content>: UIViewRepresentable where Content: View{
    let label: String
    let content: Content
    let detents: [UISheetPresentationController.Detent]

    init(_ label: String, detents: [UISheetPresentationController.Detent], @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
        self.detents = detents
    }

    func makeUIView(context: UIViewRepresentableContext<BottomSheetPresenter>) -> UIButton {
        let button = UIButton(type: .system)
        var buttonConfiguration = UIButton.Configuration.bordered()
        buttonConfiguration.cornerStyle = .medium
        buttonConfiguration.image = UIImage(systemName: "gear",
                                            withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        buttonConfiguration.imagePadding = 6.0
        button.configuration = buttonConfiguration
        button.setTitle(label, for: .normal)
        button.addAction(UIAction { _ in
            let hostingController = UIHostingController(rootView: content)
            let viewController = BottomSheetWrapperController(detents: detents)

            viewController.addChild(hostingController)
            viewController.view.addSubview(hostingController.view)
            
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: viewController.view.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
            ])
            
            hostingController.didMove(toParent: viewController)

            button.window?.rootViewController?.present(viewController, animated: true)
        }, for: .touchUpInside)

        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {
        // no updates
    }

    func makeCoordinator() -> Void {
        return ()
    }
}

/// The code in this `class` is extracted from and modified based on Donny Wals' [Using UISheetPresentationController in SwiftUI](https://www.donnywals.com/using-uisheetpresentationcontroller-in-swiftui/). I did NOT implemented this by myself.
class BottomSheetWrapperController: UIViewController {
    let detents: [UISheetPresentationController.Detent]

    init(detents: [UISheetPresentationController.Detent]) {
        self.detents = detents
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("No Storyboards")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let sheetController = self.presentationController as? UISheetPresentationController {
            sheetController.detents = detents
            sheetController.prefersGrabberVisible = true
        }
    }
}
