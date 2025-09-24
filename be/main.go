package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

type FcmMessage struct {
	RegistrationIDs []string               `json:"registration_ids,omitempty"`
	To              string                 `json:"to,omitempty"`
	Notification    map[string]string      `json:"notification"`
	Data            map[string]interface{} `json:"data,omitempty"`
}

func sendFCM(deviceTokens []string, senderName, messageContent, groupId, senderId string) {
	serverKey := "BBWyWnMFgLIyWfumekGuEG9HgYMDy55rjA_k1c3kotBNCinFbNL83RTf5Rmxmr-V4nV1Kjd1JDQEimOECtE0Xt4"

	msg := FcmMessage{
		Notification: map[string]string{
			"title": senderName,
			"body":  messageContent,
		},
		Data: map[string]interface{}{
			"groupId":      groupId,
			"senderId":     senderId,
			"message":      messageContent,
			"click_action": "FLUTTER_NOTIFICATION_CLICK", // required for Flutter
		},
	}

	if len(deviceTokens) == 1 {
		msg.To = deviceTokens[0]
	} else {
		msg.RegistrationIDs = deviceTokens
	}

	payload, _ := json.Marshal(msg)

	req, err := http.NewRequest("POST", "https://fcm.googleapis.com/v1/projects/guff-6e92b/messages:send", bytes.NewBuffer(payload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "key="+serverKey)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Println("FCM send error:", err)
		return
	}
	defer resp.Body.Close()
}

func main() {
	app := pocketbase.New()

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		// serves static files from the provided public dir (if exists)
		se.Router.GET("/{path...}", apis.Static(os.DirFS("./pb_public"), false))

		return se.Next()
	})

	app.OnRecordAfterCreateSuccess("chats").BindFunc(func(e *core.RecordEvent) error {
		groupId := e.Record.GetString("groupId")
		senderId := e.Record.GetString("userId")
		message := e.Record.GetString("message")

		// Fetch sender user record to get the name
		senderRecord, err := app.FindRecordById("users", senderId)
		if err != nil {
			log.Println("Sender not found:", err)
			return e.Next()
		}
		senderName := senderRecord.GetString("name")

		// Fetch group record to get members
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
			devices, err := app.FindRecordsByFilter("userDevices", fmt.Sprintf("user = '%s'", userId), "", 0, 0)
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

		// Send FCM asynchronously
		if len(tokens) > 0 {
			go sendFCM(tokens, senderName, message, groupId, senderId)
		}

		return e.Next()
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
