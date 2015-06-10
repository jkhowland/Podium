//
//  InviteController.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

public class InviteController: NSObject, MFMailComposeViewControllerDelegate {
    public static let sharedController = InviteController()
    
    public func invitationEmail() -> UIViewController {
    
        // Prepares email
        
        let mailViewController = MFMailComposeViewController.new()
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("You're invited to Podium")
        
        let emailBody = "This is the body of the invite. Click the link to join"
        mailViewController.setMessageBody(emailBody, isHTML: false)
        
        return mailViewController

    }
    
    public func inviteFriend(email: String) -> Invite {
        
        let fromEmail = AuthenticationController.sharedController.currentProfile!.email
        return self.inviteFromEmail(fromEmail!, email: email)
        
    }
    
    public func inviteFromEmail(fromEmail: String, email: String) -> Invite {
     
        // Creates invite object
        
        print("create invite")
        
        let invite: Invite = NSEntityDescription.insertNewObjectForEntityForName(Invite.entityName, inManagedObjectContext: Stack.defaultStack.mainContext!) as! Invite

        let profile = ProfileController.sharedController.findProfileUsingEmail(fromEmail)
        
        invite.fromUserId = profile?.identifier?.integerValue
        invite.toUserEmail = email
        invite.identifier = NSNumber(integer: (self.maxIdentifier().integerValue) + 1);
        
        return invite

    }
    
    public func receivedInvites(email: String) -> [Invite] {
    
        // Checks for invites to my email
        let request = NSFetchRequest(entityName: Invite.entityName)
        let predicate = NSPredicate(format: "toUserEmail = %@", email)
        
        request.predicate = predicate
        
        var error: NSError? = nil
        do {
            return try Stack.defaultStack.mainContext?.executeFetchRequest(request) as! [Invite]
        } catch let error1 as NSError {
            error = error1
            print(error)
            return []
        }

    }
    
    public func acceptReceivedInvites(email: String) {
    
        let invites = self.receivedInvites(email)
        
        for invite: Invite in invites {
            let friend = FriendController.sharedController.requestFriend((invite.fromUserId?.integerValue)!)
            FriendController.sharedController.acceptFriend(friend)
        }
        
    }
    
    // Needs to be refactored into a superclass
    // Needs to make unsynced identifiers negative
    func maxIdentifier() -> NSNumber {
        
        let fetchRequest = NSFetchRequest(entityName: Invite.entityName)
        fetchRequest.fetchLimit = 1;
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: false)]
        
        do {
            
            let array = try Stack.defaultStack.mainContext?.executeFetchRequest(fetchRequest)
            if array?.count > 0 {
                let invite: Invite = array?.first as! Invite
                return invite.identifier!
            } else {
                return NSNumber(integer: 0)
            }
            
        } catch {
            return NSNumber(integer: 0)
        }
        
    }

}
