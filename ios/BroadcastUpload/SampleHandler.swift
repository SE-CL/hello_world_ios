import ReplayKit
import CoreImage
import ImageIO

final class SampleHandler: RPBroadcastSampleHandler {
  private let context = CIContext(options: [.useSoftwareRenderer: false])
  private var lastSent = Date.distantPast
  private let interval: TimeInterval = 0.12

  override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
    guard sampleBufferType == .video, Date().timeIntervalSince(lastSent) >= interval,
          let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    lastSent = Date()
    let image = CIImage(cvPixelBuffer: imageBuffer)
    guard let jpeg = context.jpegRepresentation(of: image, colorSpace: CGColorSpaceCreateDeviceRGB(), options: [:]) else { return }
    // Shared container transport is intentionally lightweight; the host app polls this file.
    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.secl.hello_world_ios")!.appendingPathComponent("latest-frame.jpg")
    try? jpeg.write(to: url, options: .atomic)
  }
}
