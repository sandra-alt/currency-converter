# Currency Converter iOS App

## Project Overview

A simple, elegant iOS application that enables real-time currency conversion using live exchange rates from a public API.

## Features

- 💱 Real-time currency conversion
- 🌐 Dynamic currency selection
- 🔄 Periodic rate refreshing
- 📱 Responsive design for all iOS devices

## Technical Specifications

### Technologies Used
- Language: Swift
- Framework: UIKit
- Architecture: MVVM
- Networking: URLSession
- UI: Programmatic, Auto Layout

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

1. Clone the repository
2. Open `CurrencyConverter.xcodeproj`
3. Build and run the project

## Architecture

### Components
- `ConverterViewController`: Main UI interface
- `ConverterViewModel`: Business logic and data management
- `ConverterNetworkRepository`: API communication
- `ConverterNetworkService`: Network request handling
