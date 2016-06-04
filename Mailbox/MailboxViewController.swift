//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Sampo Karjalainen on 6/2/16.
//  Copyright © 2016 Sampo Karjalainen. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    var messageInitialCenter: CGPoint!
    var leftIconInitialCenter: CGPoint!
    var rightIconInitialCenter: CGPoint!
    var feedImageInitialCenter: CGPoint!
    let revealDistance = CGFloat(60)
    let otherActionDistance = CGFloat(260)
    let drawerOpenOffset = CGFloat(286)
    var drawerInitialX: CGFloat!
    
    let mbGray = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
    let mbYellow = UIColor(red: 251/255, green: 211/255, blue: 10/255, alpha: 1)
    let mbGreen = UIColor(red: 108/255, green: 219/255, blue: 91/255, alpha: 1)
    let mbRed = UIColor(red: 237/255, green: 83/255, blue: 41/255, alpha: 1)
    let mbBrown = UIColor(red: 217/255, green: 167/255, blue: 113/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: 320, height: 1368)
        leftIconInitialCenter = leftIconImageView.center
        rightIconInitialCenter = rightIconImageView.center
        feedImageInitialCenter = feedImageView.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.mainView.backgroundColor = self.mbGray
            self.messageView.center = messageInitialCenter
            self.messageView.alpha = 0
            UIView.animateWithDuration(0.5, animations: {
                self.messageView.alpha = 1
                self.feedImageView.center.y = self.feedImageInitialCenter.y
            })
        }
    }
    

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            messageInitialCenter = sender.view!.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            sender.view!.center.x = messageInitialCenter.x + translation.x
            
            // Icons visibility
            if translation.x < 0 {
                leftIconImageView.alpha = 0
            } else {
                rightIconImageView.alpha = 0
            }
            
            // Left icon image and background color
            if translation.x > 0 && translation.x <= revealDistance {
                leftIconImageView.image = UIImage(named: "archive_icon")
                UIView.animateWithDuration(0.2, animations: {
                    self.mainView.backgroundColor = self.mbGray
                })
            } else if translation.x > revealDistance && translation.x < otherActionDistance {
                leftIconImageView.image = UIImage(named: "archive_icon")
                UIView.animateWithDuration(0.2, animations: {
                    self.mainView.backgroundColor = self.mbGreen
                })
            } else if translation.x > otherActionDistance {
                leftIconImageView.image = UIImage(named: "delete_icon")
                UIView.animateWithDuration(0.2, animations: { 
                    self.mainView.backgroundColor = self.mbRed
                })
            }
            
            // Left icon movement
            if translation.x > 0 && translation.x <= revealDistance {
                leftIconImageView.center.x = leftIconInitialCenter.x
                leftIconImageView.alpha = translation.x / revealDistance
            } else {
                leftIconImageView.center.x = leftIconInitialCenter.x + translation.x - revealDistance
                leftIconImageView.alpha = 1
            }
            
            // Right icon image and background color
            if translation.x <= 0 && translation.x > -revealDistance {
                rightIconImageView.image = UIImage(named: "later_icon")
                UIView.animateWithDuration(0.2, animations: {
                    self.mainView.backgroundColor = self.mbGray
                })
            } else if translation.x <= -revealDistance && translation.x > -otherActionDistance {
                rightIconImageView.image = UIImage(named: "later_icon")
                UIView.animateWithDuration(0.2, animations: {
                    self.mainView.backgroundColor = self.mbYellow
                })
            } else if translation.x <= -otherActionDistance {
                rightIconImageView.image = UIImage(named: "list_icon")
                UIView.animateWithDuration(0.2, animations: {
                    self.mainView.backgroundColor = self.mbBrown
                })
            }
            
            // Right icon movement
            if translation.x <= 0 && translation.x > -revealDistance {
                rightIconImageView.center.x = rightIconInitialCenter.x
                rightIconImageView.alpha = -translation.x / revealDistance
            } else {
                rightIconImageView.center.x = rightIconInitialCenter.x + translation.x + revealDistance
                rightIconImageView.alpha = 1
            }
            
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            let translation = sender.translationInView(view)
            
            // Left side actions
            if translation.x > 0 && translation.x <= revealDistance {
                UIView.animateWithDuration(0.2, animations: {
                    sender.view!.center = self.messageInitialCenter
                })
            } else if translation.x > revealDistance && translation.x <= otherActionDistance {
                UIView.animateWithDuration(0.2, animations: {
                    self.leftIconImageView.center.x = self.leftIconInitialCenter.x + 320
                    sender.view!.center.x = self.messageInitialCenter.x + 320
                    }, completion: { (Bool) in
                        UIView.animateWithDuration(0.2, animations: { 
                            self.feedImageView.center.y = self.feedImageInitialCenter.y - 86
                        })
                        
                })
            } else if translation.x > otherActionDistance {
                UIView.animateWithDuration(0.2, animations: {
                    self.leftIconImageView.center.x = self.leftIconInitialCenter.x + 320
                    sender.view!.center.x = self.messageInitialCenter.x + 320
                    }, completion: { (Bool) in
                        UIView.animateWithDuration(0.2, animations: {
                            self.feedImageView.center.y = self.feedImageInitialCenter.y - 86
                        })
                })
            }
            
            // Right side actions
            if translation.x <= 0 && translation.x > -revealDistance {
                UIView.animateWithDuration(0.2, animations: {
                    sender.view!.center = self.messageInitialCenter
                })
            } else if translation.x <= -revealDistance && translation.x > -otherActionDistance {
                UIView.animateWithDuration(0.2, animations: {
                    self.rightIconImageView.center.x = self.rightIconInitialCenter.x - 320
                    sender.view!.center.x = self.messageInitialCenter.x - 320
                }, completion: { (Bool) in
                        UIView.animateWithDuration(0.2) {
                            self.rescheduleImageView.alpha = 1
                        }
                })
            } else if translation.x <= -otherActionDistance {
                UIView.animateWithDuration(0.2, animations: {
                    self.rightIconImageView.center.x = self.rightIconInitialCenter.x - 320
                    sender.view!.center.x = self.messageInitialCenter.x - 320
                }, completion: { (Bool) in
                    UIView.animateWithDuration(0.2) {
                        self.listImageView.alpha = 1
                    }
                })
            }
        }
    }

    @IBAction func onTapRescheduleView(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: {
            self.rescheduleImageView.alpha = 0
        }, completion: { (Bool) in
            UIView.animateWithDuration(0.2, animations: {
                self.rightIconImageView.center = self.rightIconInitialCenter
                self.messageView.center.x = self.messageInitialCenter.x
            }, completion: { (Bool) in
                self.mainView.backgroundColor = self.mbGray
            })
        })
    }
    
    @IBAction func onTapListView(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: {
            self.listImageView.alpha = 0
            }, completion: { (Bool) in
                UIView.animateWithDuration(0.2, animations: {
                    self.rightIconImageView.center = self.rightIconInitialCenter
                    self.messageView.center.x = self.messageInitialCenter.x
                }, completion: { (Bool) in
                        self.mainView.backgroundColor = self.mbGray
                })
        })
    }
    
    @IBAction func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            mainView.frame.origin.x = translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2, animations: {
                if velocity.x > 0 {
                    self.mainView.frame.origin.x = self.drawerOpenOffset
                } else {
                    self.mainView.frame.origin.x = 0
                }
                
            })
        }
        
    }
    
    @IBAction func toggleSidebar(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
            if self.mainView.frame.origin.x == 0 {
                self.mainView.frame.origin.x = self.drawerOpenOffset
            } else {
                self.mainView.frame.origin.x = 0
            }
        })
    }
    
    @IBAction func onDragHamburger(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        if sender.state == UIGestureRecognizerState.Began {
            drawerInitialX = mainView.frame.origin.x
        } else if sender.state == UIGestureRecognizerState.Changed {
            mainView.frame.origin.x = drawerInitialX + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2, animations: {
                if velocity.x > 0 {
                    self.mainView.frame.origin.x = self.drawerOpenOffset
                } else {
                    self.mainView.frame.origin.x = 0
                }
                
            })
        }
    }
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
