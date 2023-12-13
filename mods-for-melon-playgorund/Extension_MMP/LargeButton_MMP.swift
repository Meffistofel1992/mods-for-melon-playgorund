//
//  LargeButton.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 09.11.2023.
//

import Foundation

//
//  LargeButton.swift
//  Procrastinee
//
//  Created by Александр Ковалев on 21.08.2023.
//

import SwiftUI

struct LargeButton_MMP<Content: View>: View {

    @State private var isDisabled: Bool = false

    private let text: String
    private let isLoading: Bool
    private let isValid: Bool
    private let buttonHorizontalMargins: CGFloat
    private let action: EmptyClosure_MMP?
    private let asyncAction: AsyncEmptyClosure_MMP?
    private let isNeedBorder: Bool
    private let borderColor: Color
    private let fontStyle: Font
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let cornerRadius: CGFloat
    private let height: CGFloat
    private let lineWidth: CGFloat
    private let additionalContent: Content

    init(
        text: String,
        isNeedBorder: Bool = true,
        isLoading: Bool = false,
        borderColor: Color = .white,
        isValid: Bool = true,
        buttonHorizontalMargins: CGFloat = 0,
        fontStyle: Font = isIPad ? .fontWithName_MMP(.gluten, style: .semibold, size: 36) : .fontWithName_MMP(.sfProDisplay, style: .bold, size: 16),
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 12,
        height: CGFloat = isIPad ? 76 : 56,
        lineWidth: CGFloat = 1,
        action: EmptyClosure_MMP? = nil,
        asyncAction: AsyncEmptyClosure_MMP? = nil,
        @ViewBuilder additionalContent: BuilderClosure_MMP<Content> = { EmptyView() }
    ) {
        self.text = text
        self.isNeedBorder = isNeedBorder
        self.borderColor = borderColor
        self.isValid = isValid
        self.isLoading = isLoading
        self.buttonHorizontalMargins = buttonHorizontalMargins
        self.fontStyle = fontStyle
        self.action = action
        self.asyncAction = asyncAction
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.height = height
        self.lineWidth = lineWidth
        self.additionalContent = additionalContent()
    }

    var body: some View {
        HStack {
            Spacer(minLength: buttonHorizontalMargins)
            Button(action: {
                if !action.isNil {
                    action?()
                } else if !asyncAction.isNil {
                    Task {
                        await asyncAction?()
                    }
                }
            }, label: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.gray)
                } else if additionalContent is EmptyView {
                    Text(text)
                        .frame(height: height)
                        .frame(maxWidth: .infinity)
                } else {
                    additionalContent
                        .frame(height: height)
                        .frame(maxWidth: .infinity)
                }
            })
            .buttonStyle(
                LargeButtonStyle_MMP(
                    isNeedBorder: isNeedBorder,
                    isValid: isValid,
                    fontStyle: fontStyle,
                    cornerRadius: cornerRadius,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    borderColor: borderColor,
                    lineWidth: lineWidth
                )
            )
            .disabled(isDisabled)
            .disabled(!isValid)
            Spacer(minLength: buttonHorizontalMargins)
        }
    }
}

struct LargeButtonStyle_MMP: ButtonStyle {

    let isNeedBorder: Bool
    let isValid: Bool
    let fontStyle: Font
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color
    let lineWidth: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        let currentForegroundColor = !isValid || configuration.isPressed ?
        foregroundColor.opacity(0.3) :
        foregroundColor

        let currentBorderColor = !isValid || configuration.isPressed ?
        borderColor.opacity(0.3) :
        borderColor

        let backgroundColor = !isValid || configuration.isPressed ? Color.gray.opacity(0.3) : backgroundColor

        return configuration.label
            .foregroundColor(currentForegroundColor)
            .background(configuration.isPressed ? self.backgroundColor.opacity(0.3) : backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(isNeedBorder ? RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(currentBorderColor, lineWidth: lineWidth)
                     : nil)
            .font(fontStyle)
    }
}
