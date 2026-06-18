import receive_sharing_intent

class ShareViewController: RSIShareViewController {
  // Automatically redirects to the host app after sharing
  override func shouldAutoRedirect() -> Bool {
    return true
  }
}
