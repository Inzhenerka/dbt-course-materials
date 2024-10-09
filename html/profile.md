# Профиль пользователя

Сниппет предназначен для автоматической передачи профиля пользователя в PumpRoom.
Это позволяет отслеживать идентифицировать ученика, отслеживать его действия и сохранять прогресс.


```html
<!-- Сниппет для автоматической передачи профиля пользователя в PumpRoom -->
<script>
    window.addEventListener("message", event => {
        if (event.origin.endsWith(".inzhenerka-cloud.com") && event.data?.type === "getTildaProfile") {
            const profile = {...window.parent.tma__getProfileObjFromLS(), page_url: window.location.href}
            event.source.postMessage(
                { type: "setTildaProfile", profile: profile }, event.origin
            );
        }
    });
</script>
```
