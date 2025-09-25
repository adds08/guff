package main

import (
	"context"
	"log"
	"os"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"google.golang.org/api/option"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

func main() {
	app := pocketbase.New()

	// Initialize Firebase app
	opt := option.WithCredentialsFile("serviceAccount.json")
	firebaseApp, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		log.Fatalln("Failed to initialize Firebase:", err)
	}

	messagingClient, err := firebaseApp.Messaging(context.Background())
	if err != nil {
		log.Fatalln("Failed to get messaging client:", err)
	}

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		// serves static files from the provided public dir (if exists)
		se.Router.GET("/{path...}", apis.Static(os.DirFS("./pb_public"), false))
		return se.Next()
	})

	// Trigger after a chat message is created
	app.OnRecordAfterCreateSuccess("chats").BindFunc(func(e *core.RecordEvent) error {
		groupId := e.Record.GetString("groupId")
		senderId := e.Record.GetString("userId")
		message := e.Record.GetString("message")

		// Fetch sender user record to get name
		senderRecord, err := app.FindRecordById("users", senderId)
		if err != nil {
			log.Println("Sender not found:", err)
			return e.Next()
		}
		senderName := senderRecord.GetString("name")

		// Fetch group members
		groupRec, err := app.FindRecordById("groups", groupId)
		if err != nil {
			log.Println("Group not found:", err)
			return e.Next()
		}

		membersField := groupRec.Get("members")
		var memberIds []string
		if membersField != nil {
			if arr, ok := membersField.([]interface{}); ok {
				for _, m := range arr {
					if id, ok := m.(string); ok && id != senderId {
						memberIds = append(memberIds, id)
					}
				}
			}
		}

		// Fetch device tokens for members
		var tokens []string
		for _, userId := range memberIds {
			devices, err := app.FindRecordsByFilter("userDevices", "user = '"+userId+"'", "", 0, 0)
			if err != nil {
				continue
			}
			for _, d := range devices {
				t := d.GetString("fcmToken")
				if t != "" {
					tokens = append(tokens, t)
				}
			}
		}

		// Send FCM notifications asynchronously
		ctx := context.Background()
		for _, token := range tokens {
			msg := &messaging.Message{
				Token: token,
				Notification: &messaging.Notification{
					Title: senderName,
					Body:  message,
				},
				Data: map[string]string{
					"groupId":      groupId,
					"senderId":     senderId,
					"message":      message,
					"click_action": "FLUTTER_NOTIFICATION_CLICK",
				},
			}

			go func(msg *messaging.Message) {
				resp, err := messagingClient.SendDryRun(ctx, msg)
				if err != nil {
					log.Println("Error sending FCM:", err)
				} else {
					log.Println("FCM sent successfully:", resp)
				}
			}(msg)
		}

		return e.Next()
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
