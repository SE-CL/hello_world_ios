# ReplayKit Broadcast Extension

Add this folder as a Broadcast Upload Extension target in Xcode named `BroadcastUpload`.
Enable the App Group `group.com.secl.hello_world_ios` for both Runner and the extension.
The extension writes a throttled JPEG frame (`latest-frame.jpg`) to the shared container.
The host app can poll that file, crop the configured rectangle, and call the Vision channel.
