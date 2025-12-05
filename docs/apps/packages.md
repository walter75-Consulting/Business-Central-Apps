---
layout: default
title: Packages Extension
---

# 📦 walter75 - Packages

> Comprehensive packing station solution with barcode scanning, PrintNode and SendCloud integration

## 📋 Overview

A complete warehouse packing station system designed for efficient order fulfillment. Features barcode scanning workflows, automated label printing via PrintNode, and shipping integration through SendCloud. Optimized for high-volume packing operations with real-time validation and error handling.

## ✨ Features

- **Barcode Scanning Workflow**: Fast and accurate item scanning with validation
- **Packing Station Management**: Configure multiple packing stations
- **PrintNode Integration**: Automatic label printing to thermal printers
- **SendCloud Integration**: Automated shipping label creation and tracking
- **Multi-Package Support**: Handle orders with multiple packages
- **Real-time Validation**: Instant feedback on scanning errors
- **Custom Actions**: Configurable scan actions per station
- **Session Management**: Single-instance pattern for shared state

## 🔢 Object ID Range

**ID Range**: 90700-90799

## 📦 Installation

1. **Prerequisites**: Install dependencies first:
   - walter75 - PrintNode
   - walter75 - SendCloud
2. Download the latest `.app` file from [Releases](../../releases)
3. Install via Business Central Extension Management
4. Configure packing stations and scan actions

## 🔗 Dependencies

This extension requires:
- **walter75 - PrintNode** (ID: ca1ab169-0517-4532-a393-46610dd0372c)
- **walter75 - SendCloud** (ID: 1b3a8485-c38c-4802-9ce8-1f83c8a75f2e)

## 🛠️ Configuration

After installation:
1. Open **Packing Stations** page
2. Create a new packing station
3. Configure scan input field behavior
4. Set up PrintNode printer association
5. Configure SendCloud shipping options
6. Test the scanning workflow

## 📚 Documentation

### User Documentation
- 📖 **[User Guide](packages-user-guide.md)** - Complete setup and usage instructions

### Related Documentation
- [Main Documentation](../../)
- [Contributing Guidelines](../../CONTRIBUTING.md)
- [All Apps](../../)

## 🏗️ Architecture

- **SEW Packing Card**: Main UI for packing operations
- **SEW PK Actions Page**: Business logic codeunit
- **SEW PK Single Instance**: Session-scoped state management
- **Control Add-ins**: Custom JavaScript components for focus control

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.

## 💬 Support

- [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- [walter75 Consulting](https://www.walter75.de)
