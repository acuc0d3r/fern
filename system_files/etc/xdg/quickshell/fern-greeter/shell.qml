import Quickshell
import Quickshell.Services.Greetd
import QtQuick
import QtQuick.Controls

Rectangle {
    width: 800
    height: 600
    color: "black"

    Column {
        anchors.centerIn: parent
        spacing: 12

        TextField {
            id: userField
            placeholderText: "username"
        }
        TextField {
            id: passField
            placeholderText: "password"
            echoMode: TextInput.Password
        }
        Button {
            text: "Log in"
            onClicked: Greetd.createSession(userField.text)
        }
    }

    Connections {
        target: Greetd
        function onAuthMessage(message, error, responseRequired, echoResponse) {
            // greetd is asking for input (typically the password).
            // Still not fully verified: exact signal parameter names/order
            // — check actual signal signature in quickshell source before
            // relying on this parameter list.
            if (responseRequired) {
                Greetd.respond(passField.text) // METHOD NAME UNVERIFIED —
                // "respond" is a reasonable guess but not confirmed against
                // docs/source this session. Check before trusting.
            }
        }
        function onReadyToLaunch() {
            Greetd.launch(true)
        }
        function onAuthFailure(message) {
            console.log("Auth failed:", message)
        }
    }
}
