TiltingScrollView
========

UIScrollView subclass that scrolls when the user tilts the device.

##Usage##

- Change the class of your UIScrollView to TiltingScrollView.
- When your view controller appears on screen (most cases in `viewWillAppear` or `viewDidAppear`), call `scrollView.setTiltingEnabled(true)`.
- If at any point you want to stop the tilt-to-scroll, call `scrollView.setTiltingEnabled(false)`. This will automatically set `scrollView.scrollingEnabled = true`.
- You can recalibrate the scroll view at any point by calling `scrollView.calibrate()`. I recommend adding a button that allows the user to choose to recalibrate in order to redefine the angle at which the scroll view goes up and down.

##Public Variables##

```swift
/// Factor by which the accelerometer data is multiplied to scroll the view. Larger values cause faster scrolling.

public var tiltingFactor: CGFloat = 20
```

##Public Methods##

```swift
/// true: Tilting the device causes the scroll view to scroll. `scrollingEnabled = false`
/// false: Tilting the device does nothing. `scrollEnabled = true`

public func setTiltingEnabled(tiltingEnabled: Bool)
```

```swift
/// Resets the internal calculations to use the current angle of the device as the reference point.
/// At the device's current angle, the scroll view will not scroll.

public func calibrate()
```

## Conclusion

If you have any issues or suggestions, please create an issue or a pull request (preferred :). Revisions and improvements are always welcome.

You can contact me on Twitter at [@ERDekhayser](https://twitter.com/ERDekhayser).
