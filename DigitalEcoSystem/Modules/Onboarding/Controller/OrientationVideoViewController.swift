//
//  OrientationVideoViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 21/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CTVideoPlayerView

class OrientationVideoViewController: BaseViewController {

    // MARK: - Variables
    fileprivate var currentInterval: CGFloat! = 0.0
    fileprivate var totalInterval: CGFloat! = 0.0
    fileprivate var videoView: CTVideoView = CTVideoView()
    fileprivate var progress: Float = 0.0 {
        didSet {
            self.progressView.setProgress(progress, animated: true)
        }
    }

    // MARK: - IBOutlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var playerBg: UIView!
    @IBOutlet weak var progressView: UIProgressView!

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        playVideo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)

        deallocVideoPlayer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - video player installzation
    private func playVideo() {

        let path = Bundle.main.url(forResource: "Cell_Phone_policy_2.0", withExtension: "mp4")?.absoluteString

        let videoUrl: String = path!
        playerBg.layoutIfNeeded()
        var frame: CGRect = playerBg.bounds
        frame.origin.x = 0
        frame.origin.y = 0
        videoView.frame = frame
        playerBg.addSubview(videoView)
        // self.videoView.videoUrl = URL(string: videoUrl)
        videoView.prepare()
        videoView.assetToPlay = AVAsset(url: URL(string: videoUrl)!)
        videoView.play()
        videoView.timeDelegate = self
        videoView.playControlDelegate = self
        videoView.operationDelegate = self
        videoView.isSlideFastForwardDisabled = true
        videoView.shouldReplayWhenFinish = false
        videoView.isUserInteractionEnabled = false // do not allow user to play with gestures or other controls.
        videoView.setShouldObservePlayTime(true, withTimeGapToObserve: 100.0)
        doneButton.isHidden = true
        progressView.isHidden = true
    }

    // MARK: - video player dealloc
    private func deallocVideoPlayer() {
        if videoView.isPlaying {
            videoView.isMuted = true
            videoView.deleteAndCancelDownloadTask()
            videoView.stop(withReleaseVideo: true)
            videoView.deallocTime()
        }
    }

    // MARK: - Check Video is complete or not
    fileprivate func isVideoCompleted() -> Bool {
        if floor(currentInterval) == floor(totalInterval) {
            return true
        } else {
            return false
        }
    }

    // MARK: - Navigation
    func moveToWalkThrough() {
        let walkthroughViewController = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.WalkThroughIdentifier) as! WalkThroughViewController
        navigationController?.pushViewController(walkthroughViewController, animated: false)
    }

    // MARK: - Actions
    @IBAction func doneButtonAction(_: AnyObject) {
        moveToWalkThrough()
    }
}

// MARK: - CTVideoViewTimeDelegate, CTVideoViewPlayControlDelegate, CTVideoViewOperationDelegate
extension OrientationVideoViewController: CTVideoViewTimeDelegate, CTVideoViewPlayControlDelegate, CTVideoViewOperationDelegate {

    func videoViewDidLoadVideoDuration(_ videoView: CTVideoView!) {
        totalInterval = videoView.totalDurationSeconds

        doneButton.setTitle(LocalizedString.shared.skip, for: .normal)
        if isVideoCompleted() {
            doneButton.setTitle(LocalizedString.shared.doneString, for: .normal)
        } else {
            doneButton.setTitle(LocalizedString.shared.skip, for: .normal)
        }
    }

    func videoViewDidFinishPrepare(_: CTVideoView!) {
        // self.videoView.move(toSecond: playbackInterval, shouldPlay: true)
    }

    func videoViewDidFailPrepare(_: CTVideoView!,error error: Error!) {
        
        LogManager.logError("Video view did fail prepare \(error.localizedDescription)")
        /*
         showAlertViewWithMessageAndActionHandler(LocalizedString.shared.ERROR_TITLE, message: LocalizedString.shared.VIDEO_FAILURE_DESC, actionHandler: {
         self.doneButton.isHidden = false
         _ = self.navigationController?.popViewController(animated: true)
         }) */
    }

    func videoViewDidFinishPlaying(_: CTVideoView!) {
        doneButtonAction(UIButton())
    }

    func videoView(_: CTVideoView!, didPlayToSecond second: CGFloat) {
        doneButton.isHidden = false
        progressView.isHidden = false
        if second > 0 {
            progress = Float(second / totalInterval)
        }
    }
}
