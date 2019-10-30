//
//  InterfaceController.swift
//  WatchSushiGame WatchKit Extension
//
//  Created by Simran Kaur Bal on 2019-10-30.
//  Copyright © 2019 Simran Kaur Bal. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController,WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("---WATCH APP LOADED")
        
        if (WCSession.isSupported() == true) {
            //            msgFromPhoneLabel.setText("WC is supported!")
            
            // create a communication session with the phone
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        else {
            //            msgFromPhoneLabel.setText("WC NOT supported!")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
    }
    
    
    @IBAction func leftButtonPressed() {
        
        print("Sending message to phone")
        // ------ SEND MESSAGE TO WATCH CODE GOES HERE
        
        if(WCSession.default.isReachable == true){
            //            Here is the message you want to send to the watch
            let message = ["name":"left"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            //                    messageCounter = messageCounter+1
            //                                 sendMessageOutputLabel.setText("Message Sent")
        }
        else {
            //                        messageCounter = messageCounter + 1
            //                                       sendMessageOutputLabel.setText("Cannot reach watch! ")
        }
    }
    
    @IBAction func rightButtonPressed() {
        print("Sys")
        // ------ SEND MESSAGE TO WATCH CODE GOES HERE
        
        if(WCSession.default.isReachable == true){
            //            Here is the message you want to send to the watch
            let message = ["name":"right"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            //                    messageCounter = messageCounter+1
            //                                 sendMessageOutputLabel.setText("Message Sent")
        }
        else {
            //                        messageCounter = messageCounter + 1
            //                                       sendMessageOutputLabel.setText("Cannot reach watch! ")
        }
    }

}
