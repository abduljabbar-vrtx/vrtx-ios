//
//  WelcomeScreen.swift
//  Example
//
//  Created by Abdul Jabbar on 12/05/2026.
//

import UIKit
import VRTX

class WelcomeScreen: UIViewController {

    // MARK: - Welcome screen

    private enum Design {
        static let backgroundColor = UIColor(rgb: 0xF4F4EF)
        static let inkPrimary = UIColor(rgb: 0x151512)
        static let inkSecondary = UIColor(rgb: 0x57564F)
        static let accentGreen = UIColor(rgb: 0x2FCE65)
        static let buttonLabelColor = UIColor(rgb: 0x041108)

        // Safe-area-relative offsets on the design device.
        static let designSafeTop: CGFloat = 62
        static let wordmarkTop: CGFloat = 86 - designSafeTop          // 24
        static let pillTop: CGFloat = 80 - designSafeTop              // 18
        static let bandTop: CGFloat = 230 - designSafeTop             // 168

        // Text baselines, pinned with first/lastBaselineAnchor.
        static let headlineBaseline1: CGFloat = 218 - designSafeTop   // first baseline y 218
        static let subtitleBaseline1: CGFloat = 304 - designSafeTop   // first baseline y 304
        static let subtitlePenX: CGFloat = 24.2

        // Bottom-anchored elements (from the canvas bottom edge).
        static let footerBaseline2FromBottom: CGFloat = 874 - 764     // last baseline y 764
        static let buttonBottomFromSuperview: CGFloat = 874 - 832     // 42
        static let buttonTitleBaselineFromButtonTop: CGFloat = 31.15  // baseline y 811.15 from button top 780

        // Horizontal metrics.
        static let buttonHorizontalMargin: CGFloat = 16
        static let bandHeight: CGFloat = 437

        // Typography: Inter, bundled from the vrtx-sdk-ios project, with the
        // letter-spacing measured from the design frame.
        static let headlineFont = UIFont(name: "Inter-Bold", size: 38)!
        static let headlineLineHeight: CGFloat = 44
        static let headlineTracking: CGFloat = -1.3
        static let subtitleFont = UIFont(name: "Inter-Regular", size: 17)!
        static let subtitleLineHeight: CGFloat = 24
        static let subtitleTracking: CGFloat = -0.34
        static let footerFont = UIFont(name: "Inter-Regular", size: 13)!
        static let footerLineHeight: CGFloat = 18
        static let footerTracking: CGFloat = 0.07
        static let buttonFont = UIFont(name: "Inter-Medium", size: 15.42)!
        static let buttonTracking: CGFloat = -0.4
    }

    // MARK: UI elements

    private let ribbonBandView = UIImageView()
    private let wordmarkView = UIImageView(image: UIImage(named: "VrtxWordmark"))
    private let languagePill = UIView()
    private let flagView = UIImageView(image: UIImage(named: "UkFlag"))
    private let chevronView = UIImageView(image: UIImage(named: "ChevronDown"))
    private let headlineLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let footerLabel = UILabel()
    private let getStartedButton = UIButton(type: .custom)
    private let buttonTitleLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        buildWelcomeScreen()
    }

    // MARK: - Screen construction

    private func buildWelcomeScreen() {
        view.backgroundColor = Design.backgroundColor

        // Decorative ribbon band behind everything else.
        ribbonBandView.image = UIImage(named: "RibbonBand")
        ribbonBandView.contentMode = .scaleToFill
        view.addSubview(ribbonBandView)

        // "vrtx" logotype, top-left.
        wordmarkView.contentMode = .scaleAspectFit
        view.addSubview(wordmarkView)

        // Language selector pill, top-right (Union Jack + chevron).
        languagePill.backgroundColor = .white
        languagePill.layer.cornerRadius = 18
        languagePill.layer.cornerCurve = .continuous
        languagePill.isAccessibilityElement = true
        languagePill.accessibilityLabel = "Language"
        languagePill.accessibilityHint = "English (United Kingdom)"
        view.addSubview(languagePill)
        flagView.contentMode = .scaleAspectFit
        languagePill.addSubview(flagView)
        chevronView.contentMode = .scaleAspectFit
        languagePill.addSubview(chevronView)

        // Headline: "Your money,\nmade simple."
        configure(headlineLabel,
                  text: "Your money,\nmade simple.",
                  font: Design.headlineFont,
                  lineHeight: Design.headlineLineHeight,
                  tracking: Design.headlineTracking,
                  color: Design.inkPrimary,
                  alignment: .left)

        // Subtitle: "Pay, transfer and manage your money in one\nwallet."
        configure(subtitleLabel,
                  text: "Pay, transfer and manage your money in one\nwallet.",
                  font: Design.subtitleFont,
                  lineHeight: Design.subtitleLineHeight,
                  tracking: Design.subtitleTracking,
                  color: Design.inkSecondary,
                  alignment: .left)

        // Footer note, centered above the button.
        configure(footerLabel,
                  text: "Vrtx Wallet is only available to customers and employees of\nbusinesses registered with Vrtx",
                  font: Design.footerFont,
                  lineHeight: Design.footerLineHeight,
                  tracking: Design.footerTracking,
                  color: Design.inkSecondary,
                  alignment: .center)

        // "Get started" capsule button.
        getStartedButton.backgroundColor = Design.accentGreen
        getStartedButton.layer.cornerRadius = 26
        getStartedButton.layer.cornerCurve = .continuous
        getStartedButton.addTarget(self, action: #selector(btnGetStartedTapped(_:)), for: .touchUpInside)
        getStartedButton.isAccessibilityElement = true
        getStartedButton.accessibilityLabel = "Get started"
        view.addSubview(getStartedButton)

        buttonTitleLabel.attributedText = attributedText(
            "Get started",
            font: Design.buttonFont,
            lineHeight: nil,
            tracking: Design.buttonTracking,
            color: Design.buttonLabelColor,
            alignment: .center
        )
        buttonTitleLabel.textAlignment = .center
        buttonTitleLabel.isUserInteractionEnabled = false
        buttonTitleLabel.isAccessibilityElement = false
        view.addSubview(buttonTitleLabel)

        activateWelcomeConstraints()
    }

    /// Anchor-based Auto Layout, matching the SDK's programmatic style.
    /// Text blocks are pinned by their baselines (`firstBaselineAnchor` /
    /// `lastBaselineAnchor`) so lines land on the exact design baselines.
    private func activateWelcomeConstraints() {
        let guide = view.safeAreaLayoutGuide

        for subview in [ribbonBandView, wordmarkView, languagePill, headlineLabel, subtitleLabel, footerLabel, getStartedButton, buttonTitleLabel] {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        for subview in [flagView, chevronView] {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // Ribbon band: full-bleed, design y 230..667.
            ribbonBandView.topAnchor.constraint(equalTo: guide.topAnchor, constant: Design.bandTop),
            ribbonBandView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ribbonBandView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ribbonBandView.heightAnchor.constraint(equalToConstant: Design.bandHeight),

            // Wordmark: design frame (24, 86, 77.25 x 24) — the asset is the exact ink.
            wordmarkView.topAnchor.constraint(equalTo: guide.topAnchor, constant: Design.wordmarkTop),
            wordmarkView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            wordmarkView.widthAnchor.constraint(equalToConstant: 77.25),
            wordmarkView.heightAnchor.constraint(equalToConstant: 24),

            // Language pill: design frame (328, 80, 58 x 36).
            languagePill.topAnchor.constraint(equalTo: guide.topAnchor, constant: Design.pillTop),
            languagePill.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            languagePill.widthAnchor.constraint(equalToConstant: 58),
            languagePill.heightAnchor.constraint(equalToConstant: 36),

            // Flag circle: (334, 86, 24 x 24) relative to the pill.
            flagView.leadingAnchor.constraint(equalTo: languagePill.leadingAnchor, constant: 6),
            flagView.topAnchor.constraint(equalTo: languagePill.topAnchor, constant: 6),
            flagView.widthAnchor.constraint(equalToConstant: 24),
            flagView.heightAnchor.constraint(equalToConstant: 24),

            // Chevron ink centered at (370, 98) — 13pt right of the pill centre.
            chevronView.centerXAnchor.constraint(equalTo: languagePill.centerXAnchor, constant: 13),
            chevronView.centerYAnchor.constraint(equalTo: languagePill.centerYAnchor),
            chevronView.widthAnchor.constraint(equalToConstant: 7.44),
            chevronView.heightAnchor.constraint(equalToConstant: 4.36),

            // Headline: first baseline on design y 218 (pen x 24.6).
            headlineLabel.firstBaselineAnchor.constraint(equalTo: guide.topAnchor, constant: Design.headlineBaseline1),
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.6),
            headlineLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),

            // Subtitle: first baseline on design y 304 (pen x 24.2).
            subtitleLabel.firstBaselineAnchor.constraint(equalTo: guide.topAnchor, constant: Design.subtitleBaseline1),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.subtitlePenX),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),

            // Footer: last baseline 110pt above the canvas bottom, centered.
            // Wide leading/trailing so the 368pt design line can never wrap.
            footerLabel.lastBaselineAnchor.constraint(equalTo: view.bottomAnchor, constant: -Design.footerBaseline2FromBottom),
            footerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footerLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 8),
            footerLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -8),

            // Button: design frame (16, 780, width-32 x 52).
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.buttonHorizontalMargin),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Design.buttonHorizontalMargin),
            getStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Design.buttonBottomFromSuperview),
            getStartedButton.heightAnchor.constraint(equalToConstant: 52),

            // Button title: first baseline on design y 811.15 (31.15pt below the button top).
            buttonTitleLabel.firstBaselineAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: Design.buttonTitleBaselineFromButtonTop),
            buttonTitleLabel.centerXAnchor.constraint(equalTo: getStartedButton.centerXAnchor),
            buttonTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: getStartedButton.leadingAnchor),
            buttonTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: getStartedButton.trailingAnchor),
        ])
    }

    // MARK: - Text helpers

    private func configure(_ label: UILabel,
                           text: String,
                           font: UIFont,
                           lineHeight: CGFloat?,
                           tracking: CGFloat,
                           color: UIColor,
                           alignment: NSTextAlignment) {
        label.attributedText = attributedText(text, font: font, lineHeight: lineHeight, tracking: tracking, color: color, alignment: alignment)
        label.numberOfLines = 0
        label.textAlignment = alignment
        view.addSubview(label)
    }

    /// Builds the styled string, applying tracking to every character except the
    /// last of each line so centered lines stay optically centered.
    private func attributedText(_ text: String,
                                font: UIFont,
                                lineHeight: CGFloat?,
                                tracking: CGFloat,
                                color: UIColor,
                                alignment: NSTextAlignment) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        if let lineHeight = lineHeight {
            paragraph.minimumLineHeight = lineHeight
            paragraph.maximumLineHeight = lineHeight
        }

        let result = NSMutableAttributedString()
        let lines = text.components(separatedBy: "\n")
        for (index, line) in lines.enumerated() {
            let lineString = NSMutableAttributedString(string: line, attributes: [
                .font: font,
                .foregroundColor: color,
                .paragraphStyle: paragraph
            ])
            if tracking != 0, !line.isEmpty {
                lineString.addAttribute(.kern, value: tracking, range: NSRange(location: 0, length: line.count - 1))
            }
            result.append(lineString)
            if index < lines.count - 1 {
                result.append(NSAttributedString(string: "\n", attributes: [
                    .font: font,
                    .foregroundColor: color,
                    .paragraphStyle: paragraph
                ]))
            }
        }
        return result
    }

    // MARK: - VRTX SDK setup (unchanged example flow)

    private func makeExampleTheme() -> ThemeOptions {
        let theme = ThemeOptions()

        theme.cardImage = .remote(URL(string: "https://example.com/card.png")!)
        theme.brandLogo = .remote(URL(string: "https://example.com/logo.png")!)
        theme.brandName = "Atlas Pay"

        theme.colors = VrtxColors(
            allBrands: VrtxColors.AllBrands(
                primary: "#377DFF",
                buttonLabel: "#FFFFFF"
            ),
            labels: VrtxColors.Labels(
                primary: "#12233D",
                secondary: "#60708A",
                tertiary: "#8B9AB2",
                quaternary: "#B8C4D6"
            ),
            fills: VrtxColors.Fills(
                primary: "#EAF3FF",
                secondary: "#DCEAFF",
                tertiary: "#C5D9F5",
                quaternary: "#ADC8EC",
                vibrant: VrtxColors.Fills.Vibrant(secondary: "#4DE3D1")
            ),
            backgrounds: VrtxColors.Backgrounds(
                primary: "#F4F8FF",
                secondary: "#F7FAFF"
            ),
            backgroundsGradient: VrtxColors.BackgroundsGradient(
                wb01: "#EAF3FF",
                wb02: "#E7F5F6"
            ),
            accents: VrtxColors.Accents(
                red: "#E05252",
                redBg: "#FFE7E7",
                green: "#2E9B67",
                greenBg: "#E1F5EA"
            )
        )

        theme.spacing = VrtxSpacing(
            x0: 0, xxs: 2, xs: 4, sm: 8, md: 12,
            ml: 16, lg: 20
        )
        theme.radius = VrtxRadius(
            s: 6, sm: 8, md: 12, ml: 16, lg: 20,
            xl: 24, full: 999, huge: 64
        )

        return theme
    }

    @IBAction func btnGetStartedTapped(_ sender: Any) {
        let clientID = Bundle.main.object(forInfoDictionaryKey: "VrtxClientID") as? String ?? ""
        let clientSecret = Bundle.main.object(forInfoDictionaryKey: "VrtxClientSecret") as? String ?? ""
        let externalReference = "ios-example-\(UUID().uuidString)"

        Vrtx.setup(
            environment: .sandbox,
            clientID: clientID,
            clientSecret: clientSecret,
            mode: .light,
            language: .english,
            externalReference: externalReference,
            fontFamily: "Inter",
            designOption: .optionC, // .optionA, .optionB, or .optionC
            theme: makeExampleTheme(),
            onSuccess: {
                // SDK UI launched
            },
            onError: { [weak self] error in
                let alert = UIAlertController(
                    title: "Error \(error.status)",
                    message: error.message,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            },
            onExit: {
                // SDK UI dismissed
            }
        )
    }
}

private extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1
        )
    }
}
