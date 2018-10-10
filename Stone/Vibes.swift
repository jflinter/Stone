//
//  Vibes.swift
//  Stone
//
//  Created by Jack Flintermann on 5/9/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

enum Vibe: String, Codable {
    
    case Balance = "balance"
    case Calm = "calm"
    case Clarity = "clarity"
    case Cleansing = "cleansing"
    case Communication = "communication"
    case Confidence = "confidence"
    case Courage = "courage"
    case Creativity = "creativity"
    case Dreamwork = "dreamwork"
    case Focus = "focus"
    case Grounding = "grounding"
    case Insight = "insight"
    case Intuition = "intuition"
    case Joy = "joy"
    case Love = "love"
    case Manifestation = "manifestation"
    case Motivation = "motivation"
    case Passion = "passion"
    case Peace = "peace"
    case Protection = "protection"
    case Strength = "strength"
    case Transformation = "transformation"
    case Vitality = "vitality"
    
    var image: UIImage? {
        switch self {
        case .Balance: return Resource.Image.Icons.Balance.image
        case .Calm: return Resource.Image.Icons.Calm.image
        case .Clarity: return Resource.Image.Icons.Clarity.image
        case .Cleansing: return Resource.Image.Icons.Cleansing.image
        case .Communication: return Resource.Image.Icons.Communication.image
        case .Confidence: return Resource.Image.Icons.Confidence.image
        case .Courage: return Resource.Image.Icons.Courage.image
        case .Creativity: return Resource.Image.Icons.Creativity.image
        case .Dreamwork: return Resource.Image.Icons.Dreamwork.image
        case .Focus: return Resource.Image.Icons.Focus.image
        case .Grounding: return Resource.Image.Icons.Grounding.image
        case .Insight: return Resource.Image.Icons.Insight.image
        case .Intuition: return Resource.Image.Icons.Intuition.image
        case .Joy: return Resource.Image.Icons.Joy.image
        case .Love: return Resource.Image.Icons.Love.image
        case .Manifestation: return Resource.Image.Icons.Manifestation.image
        case .Motivation: return Resource.Image.Icons.Motivation.image
        case .Passion: return Resource.Image.Icons.Passion.image
        case .Peace: return Resource.Image.Icons.Peace.image
        case .Protection: return Resource.Image.Icons.Protection.image
        case .Strength: return Resource.Image.Icons.Strength.image
        case .Transformation: return Resource.Image.Icons.Transformation.image
        case .Vitality: return Resource.Image.Icons.Vitality.image
        }
    }
}

