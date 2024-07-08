# Отслеживание пользователя

Отправка события в базу и предоставление профиля другим приложениям.

```html
<script>
    function trackUser(profile, event) {
        // Endpoint URL
        const endpoint =
            "https://pump-room-api.inzhenerka-cloud.com/track_user";
        const data = {
            user: profile.login,
            project_id: profile.projectid,
            event: event,
        };
        fetch(endpoint, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(data),
        });
    }
    // Listen for messages from the iframe
    window.addEventListener(
        "message",
        function (event) {
            // Verify the origin of the message
            if (
                event.origin !== "https://pump-room-quiz.inzhenerka-cloud.com"
            ) {
                return;
            }
            // Check if the message requests to call the external function
            if (event.data && event.data.type === "getTildaProfile") {
                const data = window.parent.tma__getProfileObjFromLS();
                event.source.postMessage(
                    { type: event.data.type, data: data },
                    event.origin
                );
            }
        },
        false
    );
    setTimeout(function () {
        const profile = window.parent.tma__getProfileObjFromLS();
        trackUser(profile, "page_load");
    }, 5000);
</script>
```
