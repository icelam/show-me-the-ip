<p align="center">
    <img alt="Show me the IP" src="./logo/appicon.svg" width="220" />
</p>
<h1 align="center">Show me the IP</h1>
<p align="center">
    macOS application to show internal IP address (e.g. 192.168.1.1) on application menu bar.
</p>
<p align="center">
    <a href="https://swift.org/"><img height="20" src="https://img.shields.io/badge/made_with-Swift_4-f05138.svg?logo=swift&logoColor=white" alt="Made with Swift 4"></a>
    <a href="./LICENSE"><img height="20" src="https://img.shields.io/github/license/icelam/show-me-the-ip?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAEFCu8CAAAABGdBTUEAALGPC/xhBQAAADhlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAqACAAQAAAABAAAAHKADAAQAAAABAAAAHAAAAABHddaYAAAC5UlEQVRIDd2WPWtVQRCGby5pVASLiGghQSxyG8Ui2KWwCfkH9olY2JneQkiR0oCIxH/gB+qVFDYBIWBAbAIRSbCRpLXwIxLiPT7vnNm9e87ZxJtUwYH3zO47Mzv7Mbv3tlo5KYriGtgAJ81OY1ENdG/YI4boFEOI911BXgY/pdtwGuAtXpvmB1tAXHDnUolE5urkPOQo6MqA3pXWmJJL4Bb4rQ7yEYfxsjnIF29NJIoNC6e5fxOL/qN+9KCz7AaLpN8zI415N2i2EptpGrkRIjGeAuvR6IY1hSFLFUOug9Ms2M7ZxIUNytm1mnME186sdI2BOCwAyQMg54ugzSmKmwbPwSbolKH+hbAtQdsOoF+BsF3anUVwBdiOWRidFZDKTTrKEAJTm3GVrGkHzw/uPZbyx7DNNLfB7KGmRsCcr+/gjaiPSpAOTyX9qG4L/XBDdWXDDf1M+wtQ5fwCOtcb4Dto6VpLmzByB6gqdHbTItGSJdAGqibJQhmRfCF7IN4beSF2G9CqnGXQrxofXU+EykllNeoczRgYytDKMubDIRK0g5MF8rE69cGu0u9nlUcqaUZ41W0qK2nGcSzr4D2wV9U9wxp1rnpxn8agXAOHMQ9cy9kbHM7ngY4gFb03TxrO/yfBUifTtXt78jCrjY/jgEFnMn45LuNWUtknuu7NSm7D3QEn3HbatV1Q2jvgIRf1sfODKQaeymxZoMLlTqsq1LF+HvaTqQOzEzUCfni0/eNIA+DfuE3KEtbsegckGmMktTXacnBHPVe687ugkpT+axCkkhBSyRSjWI2xf1KMMVmYiQdWksK9BEFiQoiYLIlvJA3/zeTzCejP0RbB6YPbhZuB+0pR3KcdX0LaJtju0ZgBL8Bd+sbz2QIaU2OfBX3BaQLsgZysQtrk0M8Sh1A0w3DyyYnGnAiZ4gqZ/TvI2A8OGd1YIbF7+F3P+B6dYpYdsJNZgrjO0UdOIhmom0nwL0pnfnzkL1803jAoKhvyAAAAAElFTkSuQmCC" alt="License"></a>
    <a href="https://github.com/icelam/show-me-the-ip/releases"><img alt="Current version" src="https://img.shields.io/github/v/release/icelam/show-me-the-ip.svg?sort=semver&label=latest&logo=github"/></a>
</p>

## Installation ##
1. You can get the latest version [here](https://github.com/icelam/show-me-the-ip/releases/latest)
2. Download the `Application.zip`, unzip it and copy `Show me the IP.app` to your `/Applications` folder

## Development ##
Below are some tips for you to start the projects locally.

### Environments Setup ###
You will need to have:
* macOS 10.14.x
* Xcode 10.3

### Running the app ###
You can run and debug the app using any of the ways listed below: 
* Press the little `Play` button on the upper left corner on the Xcode window
* Press `cmd + R`
* Choose `Project > Run` in the Xcode application menu

### Packaging for release ###
The steps for packaging a release includes:
1. Bumping the "Bundle versions string, short" and "Bundle version" in `Show me the IP/Info.plist`
2. Choose `Project > Archive` in the Xcode application menu
3. Choose `Distribute App` in the popup window, select `Copy App` option

### Dependencies
* To detech the network change, [Reachability.swift](https://github.com/ashleymills/Reachability.swift) is used
